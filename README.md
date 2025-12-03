# Secret Chat 🔐

A real-time, end-to-end encrypted chat application. Create private rooms, share links, and chat securely with RSA encryption.

## Features

- **End-to-End Encryption** — RSA-OAEP 2048-bit encryption. Messages are encrypted on your device before being sent.
- **Private Rooms** — Generate unique 12-character room IDs. Share a link, and only two people can join.
- **Real-Time Messaging** — Powered by Socket.IO for instant message delivery.
- **Zero Server Storage** — Messages are never stored. When you leave, they're gone.
- **No Account Required** — Just open the app and start chatting.

## Quick Start

```bash
# Clone
git clone https://github.com/omareltomy/secret-chat.git
cd secret-chat

# Install
npm install

# Run
npm start
```

Open [http://localhost:3000](http://localhost:3000)

## How It Works

1. **Create a Room** — Click to generate a new private room
2. **Share the Link** — Copy and send the room link to someone
3. **Chat Securely** — Once both users join, messages are encrypted end-to-end

## Tech Stack

| Layer | Technology |
|-------|------------|
| Server | Node.js, Express, Socket.IO |
| Client | Vanilla JS, HTML5, CSS3 |
| Encryption | Web Crypto API (RSA-OAEP) |

## Deployment

### DigitalOcean App Platform

1. Push to GitHub
2. Create new App in DigitalOcean
3. Connect your repository
4. Add environment variable: `CLIENT_ORIGIN=*`
5. Deploy

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Server port | `3000` |
| `NODE_ENV` | Environment | `development` |
| `CLIENT_ORIGIN` | CORS allowed origin | `*` |

## Security

- RSA-OAEP 2048-bit encryption
- Private keys never leave the browser
- No message persistence
- XSS protection via `textContent`
- Configurable CORS

## License

MIT
