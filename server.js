import { Server } from "socket.io";
import express from "express";
import { createServer } from "http"

const app = express();

app.use(express.static('public'));

const httpServer = createServer(app);

const io = new Server(httpServer, { cors: ['localhost:3000','https://j3kjvmlc-3000.uks1.devtunnels.ms'] });

const rooms = new Map();

function generateRoomId() {
  return Math.random().toString(36).substring(2, 8).toUpperCase();
}
io.on('connection', socket => {
    console.log(socket.id)
    socket.emit('uid',socket.id)
    socket.on('create-room', () => {
        const roomId = generateRoomId();
        joinRoom(socket,roomId)
   })
     socket.on("join-room", (roomId) => {
    joinRoom(socket, roomId);
  });
    socket.on('message-from-client-to-server', (message) => {
    io.emit('message-to-all', {message:message, sender:socket.id})
    })
})

httpServer.listen(3000, () => {
    console.log(`server started on port 3000`)
})