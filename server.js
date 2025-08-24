import { Server } from "socket.io";
import express from "express";
import { createServer } from "http";
import path from "path";
import { fileURLToPath } from "url";

// ES Module __dirname equivalent
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';

// Security middleware
app.use(express.static('public'));
app.disable('x-powered-by');

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({ 
        status: 'OK', 
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});

const httpServer = createServer(app);

// Production-ready CORS configuration
const corsOptions = {
    origin: NODE_ENV === 'production' 
        ? [process.env.CLIENT_URL, /\.railway\.app$/, /\.up\.railway\.app$/]
        : ['http://localhost:3000', 'http://127.0.0.1:3000'],
    methods: ["GET", "POST"],
    credentials: true
};

const io = new Server(httpServer, { 
    cors: corsOptions,
    transports: ['websocket', 'polling']
});

const rooms = new Map();
const userRooms = new Map();
function generateRoomId() {
  return Math.random().toString(36).substring(2, 14).toUpperCase();
}
io.on('connection', socket => {
    console.log(socket.id)
    socket.emit('uid',socket.id)
    socket.on('create-room', (data) => {
        const roomId = generateRoomId();
        joinRoom(socket, roomId, data.publicKey);
   })
     socket.on("join-room", (data) => {
    joinRoom(socket, data.roomId, data.publicKey);
  });
    socket.on('message-from-client-to-server', (data) => {
        const userRoom = getUserRoom(socket.id)
        if (userRoom) {
            socket.to(userRoom).emit('message-to-room', {
                message: data.message,
                encryptedMessage: data.encryptedMessage,
                senderId: data.senderId,
                timestamp: Date.now()
            })
        }
    })
    socket.on('disconnect', () => {
        console.log("User disconnected:", socket.id);
        leaveCurrentRoom(socket);
    })
})
function joinRoom(socket, roomId, publicKey) {
  // If user is already in a room, leave it first
  const currentRoom = userRooms.get(socket.id);
  if (currentRoom) {
    leaveCurrentRoom(socket);
  }

  // Check if room exists and has space
  if (rooms.has(roomId)) {
    const room = rooms.get(roomId);
    
    if (room.sockets.size >= 2) {
      socket.emit("room-full", roomId);
      return;
    }
    
    // Join existing room
    socket.join(roomId);
    room.sockets.add(socket.id);
    room.users.set(socket.id, { publicKey });
    userRooms.set(socket.id, roomId);
    
    // Get other user's public key
    const otherUsers = Array.from(room.users.entries()).filter(([id]) => id !== socket.id);
    const otherUserPublicKey = otherUsers.length > 0 ? otherUsers[0][1].publicKey : null;
    
    socket.emit("room-joined", {
      roomId,
      userCount: room.sockets.size,
      otherUserPublicKey: otherUserPublicKey
    });
    
    // Notify room about new user
    socket.to(roomId).emit("user-joined", {
      userCount: room.sockets.size,
      publicKey: publicKey
    });
    
    console.log(`User ${socket.id} joined room ${roomId} (${room.sockets.size}/2)`);
    
  } else {
    // Create new room
    socket.join(roomId);
    rooms.set(roomId, {
      sockets: new Set([socket.id]),
      users: new Map([[socket.id, { publicKey }]]),
      createdAt: Date.now()
    });
    userRooms.set(socket.id, roomId);
    
    socket.emit("room-created", {
      roomId,
      userCount: 1
    });
    
    console.log(`Room ${roomId} created by user ${socket.id}`);
  }
}
function leaveCurrentRoom(socket) {
  const roomId = userRooms.get(socket.id);
  if (!roomId) return;

  // Remove from room tracking
  if (rooms.has(roomId)) {
    const room = rooms.get(roomId);
    room.sockets.delete(socket.id);
    room.users.delete(socket.id);
    
    // Leave socket.io room
    socket.leave(roomId);
    
    // Notify remaining users
    socket.to(roomId).emit("user-left");
    
    // Clean up empty rooms
    if (room.sockets.size === 0) {
      rooms.delete(roomId);
      console.log(`Room ${roomId} deleted - empty`);
    }
  }
  
  // Remove user from room mapping
  userRooms.delete(socket.id);
}
function getUserRoom(socketId) {
  return userRooms.get(socketId);
}

// Graceful shutdown
process.on('SIGTERM', () => {
    console.log('SIGTERM received, shutting down gracefully');
    httpServer.close(() => {
        console.log('Process terminated');
    });
});

process.on('SIGINT', () => {
    console.log('SIGINT received, shutting down gracefully');
    httpServer.close(() => {
        console.log('Process terminated');
    });
});

httpServer.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Server running on port ${PORT} in ${NODE_ENV} mode`);
    console.log(`🌐 Environment: ${NODE_ENV}`);
    if (NODE_ENV === 'development') {
        console.log(`🔗 Local: http://localhost:${PORT}`);
    }
})