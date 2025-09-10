# 🔐 Secure Chat Application

A real-time, end-to-end encrypted chat application built with Node.js, Socket.IO, and RSA encryption. Production-ready for DigitalOcean deployment.

## ✨ Features

- **End-to-End Encryption**: Messages are encrypted using RSA-2048 encryption
- **Real-time Communication**: Powered by Socket.IO for instant messaging
- **Private Rooms**: Create or join private chat rooms with unique IDs
- **Production Ready**: Optimized for DigitalOcean App Platform
- **Responsive Design**: Works on desktop and mobile devices
- **Zero Dependencies Frontend**: Pure JavaScript, no frameworks needed

## 🚀 Quick Start

### Local Development

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd secure-chat-app
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Start the development server**
   ```bash
   npm run dev
   ```

4. **Open your browser**
   Navigate to `http://localhost:3000`

### Production Deployment on DigitalOcean

#### Method 1: App Platform (Recommended)

1. **Push your code to GitHub**
2. **Log into [DigitalOcean](https://cloud.digitalocean.com/)**
3. **Go to "Apps" → "Create App"**
4. **Connect your GitHub repository**
5. **DigitalOcean will auto-detect the configuration from `.do/app.yaml`**
6. **Click "Create Resources"**

#### Method 2: Droplet Deployment

1. **Create a Ubuntu droplet**
2. **SSH into your droplet**
3. **Install Node.js and npm**
   ```bash
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   ```
4. **Clone and setup your app**
   ```bash
   git clone <your-repo-url>
   cd secure-chat-app
   npm install
   ```
5. **Install PM2 for process management**
   ```bash
   sudo npm install -g pm2
   pm2 start server.js --name "chat-app"
   pm2 startup
   pm2 save
   ```
6. **Setup reverse proxy with Nginx** (optional)

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the root directory:

```bash
NODE_ENV=production
PORT=3000
CLIENT_URL=https://your-domain.com
```

### DigitalOcean Environment Variables

The app automatically configures these variables:
- `NODE_ENV=production`
- `CLIENT_URL=${APP_URL}` (auto-generated)
- `PORT` (auto-assigned)

## 📁 Project Structure

```
secure-chat-app/
├── server.js              # Main server file
├── package.json           # Dependencies and scripts
├── .do/app.yaml          # DigitalOcean configuration
├── .env.example          # Environment variables template
├── public/               # Frontend files
│   ├── index.html        # Main HTML file
│   ├── script.js         # Client-side JavaScript
│   ├── styles.css        # Styles
│   └── fonts/           # Custom fonts
└── README.md            # This file
```

## 🔒 Security Features

- **RSA-2048 Encryption**: All messages are encrypted client-side
- **No Message Storage**: Messages are not stored on the server
- **CORS Protection**: Properly configured for production
- **XSS Protection**: Headers disabled and sanitized
- **Room Isolation**: Users can only see messages in their room

## 🛠️ API Endpoints

- `GET /` - Serve the chat application
- `GET /health` - Health check endpoint for monitoring
- WebSocket events handled by Socket.IO

## 📱 How to Use

1. **Create a Room**: Visit the app and it will automatically create a private room
2. **Share the Link**: Copy the room link and share it with someone
3. **Start Chatting**: Once they join, you can start encrypted messaging
4. **Private & Secure**: Only the two people in the room can see the messages

## 🔧 Development

### Available Scripts

- `npm start` - Start the production server
- `npm run dev` - Start development server with nodemon
- `npm run build` - No build step required (outputs message)

### Adding Features

1. **Message Persistence**: Add database integration (MongoDB, PostgreSQL)
2. **User Authentication**: Implement login system
3. **File Sharing**: Add encrypted file transfer
4. **Group Chats**: Support for more than 2 users per room

## 📊 Monitoring

The app includes:
- Health check endpoint at `/health`
- Console logging for connections and errors
- Automatic room cleanup every 30 minutes
- Graceful shutdown handling

## 🚨 Troubleshooting

### Common Issues

1. **Connection Failed**
   - Check your internet connection
   - Verify the server is running
   - Check browser console for errors

2. **Encryption Errors**
   - Refresh the page to regenerate keys
   - Check if Web Crypto API is supported

3. **Room Full Error**
   - Rooms are limited to 2 users
   - Create a new room instead

### Production Issues

1. **App Won't Start**
   - Check environment variables
   - Verify Node.js version (>=18.0.0)
   - Check DigitalOcean logs

2. **CORS Errors**
   - Verify CLIENT_URL environment variable
   - Check DigitalOcean app domain

## 📄 License

MIT License - see LICENSE file for details

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

- Create an issue on GitHub
- Check the troubleshooting section
- Review DigitalOcean documentation

---

**🔐 Remember**: This app provides end-to-end encryption for your privacy, but always be cautious about what you share online.
