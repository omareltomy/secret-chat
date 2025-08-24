# Secure Chat App

A real-time end-to-end encrypted chat application built with Socket.io and RSA encryption.

## Features

- 🔐 End-to-end encryption using RSA-OAEP
- 🚀 Real-time messaging with Socket.io
- 🎨 Modern UI with custom fonts
- 📱 Mobile-responsive design
- 🔒 Private rooms with unique IDs
- 🌐 Production-ready deployment

## Tech Stack

- **Backend**: Node.js, Express, Socket.io
- **Frontend**: Vanilla JavaScript, HTML5, CSS3
- **Encryption**: Web Crypto API (RSA-OAEP)
- **Deployment**: Railway

## Getting Started

### Prerequisites

- Node.js >= 18.0.0
- npm >= 8.0.0

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd socket-chat
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm run dev
```

4. Open http://localhost:3000 in your browser

### Production Deployment

The app is configured for deployment on Railway:

1. Push to GitHub
2. Connect repository to Railway
3. Deploy automatically

## Environment Variables

Create a `.env` file based on `.env.example`:

```bash
NODE_ENV=production
PORT=3000
CLIENT_URL=https://your-app-name.up.railway.app
```

## Security

- All messages are encrypted end-to-end using RSA-OAEP
- Private keys never leave the client
- XSS protection through proper text rendering
- CORS configured for production

## Scripts

- `npm start` - Start production server
- `npm run dev` - Start development server with nodemon
- `npm run build` - No build step required (static assets)

## License

MIT License
