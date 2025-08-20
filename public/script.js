const socket = io();
let myId = "";
let currentRoomId = "";
let userCount = 1;
let myKeyPair = null;
let otherUserPublicKey = null;

// UI Elements
let roomInterface, chatContainer, roomIdDisplay, connectionStatus, copyLinkBtn;

// RSA Encryption functions
async function generateKeyPair() {
    return await window.crypto.subtle.generateKey({
        name: "RSA-OAEP",
        modulusLength: 2048,
        publicExponent: new Uint8Array([1, 0, 1]),
        hash: "SHA-256",
    }, true, ["encrypt", "decrypt"]);
}

async function exportPublicKey(key) {
    const exported = await window.crypto.subtle.exportKey("spki", key);
    return Array.from(new Uint8Array(exported));
}

async function importPublicKey(keyData) {
    return await window.crypto.subtle.importKey("spki", new Uint8Array(keyData), {
        name: "RSA-OAEP",
        hash: "SHA-256",
    }, true, ["encrypt"]);
}

async function encryptMessage(message, publicKey) {
    const encoder = new TextEncoder();
    const data = encoder.encode(message);
    const encrypted = await window.crypto.subtle.encrypt({ name: "RSA-OAEP" }, publicKey, data);
    return Array.from(new Uint8Array(encrypted));
}

async function decryptMessage(encryptedData, privateKey) {
    try {
        const decrypted = await window.crypto.subtle.decrypt({ name: "RSA-OAEP" }, privateKey, new Uint8Array(encryptedData));
        return new TextDecoder().decode(decrypted);
    } catch (error) {
        return '[Decryption failed]';
    }
}

document.addEventListener('DOMContentLoaded', () => {
    // Get UI elements
    roomInterface = document.getElementById('room-interface');
    chatContainer = document.getElementById('chat-container');
    roomIdDisplay = document.getElementById('room-id-display');
    connectionStatus = document.getElementById('connection-status');
    copyLinkBtn = document.getElementById('copy-link-btn');
    
    // Copy link button
    copyLinkBtn.addEventListener('click', () => {
        const roomUrl = `https://j3kjvmlc-3000.uks1.devtunnels.ms/?room=${currentRoomId}`;
        navigator.clipboard.writeText(roomUrl);
        copyLinkBtn.textContent = '✅ Copied!';
        setTimeout(() => {
            copyLinkBtn.textContent = '📋 Copy Room Link';
        }, 2000);
    });
    
    // Message form
    const form = document.querySelector('#my-form');
    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        const message = e.target.elements[0].value.trim();
        
        if (!message) return;
        
        // Encrypt message if we have the other user's public key
        if (otherUserPublicKey) {
            const encryptedMessage = await encryptMessage(message, otherUserPublicKey);
            socket.emit('message-from-client-to-server', {
                encryptedMessage: encryptedMessage,
                senderId: myId
            });
        } else {
            // Send unencrypted if no encryption available
            socket.emit('message-from-client-to-server', {
                message: message,
                senderId: myId
            });
        }
        
        addMessage(message, true);
        e.target.elements[0].value = "";
    });
    
    // Check URL for room parameter
    const urlParams = new URLSearchParams(window.location.search);
    const roomParam = urlParams.get('room');
    
    // Wait for socket connection
    socket.on('connect', async () => {
        myId = socket.id;
        
        // Generate RSA key pair
        myKeyPair = await generateKeyPair();
        const publicKeyData = await exportPublicKey(myKeyPair.publicKey);
        
        if (roomParam) {
            // Join specific room from URL
            socket.emit('join-room', {
                roomId: roomParam.toUpperCase(),
                publicKey: publicKeyData
            });
        } else {
            // Create new room
            socket.emit('create-room', {
                publicKey: publicKeyData
            });
        }
    });
});

// Socket events
socket.on('room-created', (data) => {
    currentRoomId = data.roomId;
    userCount = data.userCount;
    showRoomInfo();
});

socket.on('room-joined', async (data) => {
    currentRoomId = data.roomId;
    userCount = data.userCount;
    
    // Import other user's public key if available
    if (data.otherUserPublicKey) {
        otherUserPublicKey = await importPublicKey(data.otherUserPublicKey);
    }
    
    showRoomInfo();
    
    if (data.userCount === 2) {
        showChat();
    }
});

socket.on('user-joined', async (data) => {
    userCount = data.userCount;
    
    // Import the new user's public key
    if (data.publicKey) {
        otherUserPublicKey = await importPublicKey(data.publicKey);
    }
    
    showRoomInfo();
    
    if (data.userCount === 2) {
        showChat();
        addMessage("Someone joined the chat! 🔐", false, true);
    }
});

socket.on('user-left', () => {
    userCount = 1;
    otherUserPublicKey = null;
    hideChat();
    addMessage("Other user left", false, true);
});

socket.on('message-to-room', async (data) => {
    if (data.encryptedMessage && myKeyPair) {
        const decryptedMessage = await decryptMessage(data.encryptedMessage, myKeyPair.privateKey);
        addMessage(decryptedMessage, false);
    } else if (data.message) {
        addMessage(data.message, false);
    }
});

socket.on('room-full', (roomId) => {
    alert(`Room ${roomId} is full!`);
});

// Helper functions
function showRoomInfo() {
    roomIdDisplay.textContent = currentRoomId;
    
    if (userCount === 1) {
        connectionStatus.textContent = "Waiting for someone to join...";
        connectionStatus.style.color = "#ff6b35";
    } else {
        connectionStatus.textContent = "Connected! 🔐";
        connectionStatus.style.color = "#28a745";
    }
    
    if (document.getElementById('user-count')) {
        document.getElementById('user-count').textContent = `${userCount}/2 users`;
    }
}

function showChat() {
    roomInterface.style.display = 'none';
    chatContainer.style.display = 'block';
    document.getElementById('chat-room-id').textContent = `Room: ${currentRoomId} 🔐`;
    document.getElementById('user-count').textContent = `${userCount}/2 users`;
}

function hideChat() {
    roomInterface.style.display = 'block';
    chatContainer.style.display = 'none';
    showRoomInfo();
}

function addMessage(messageText, isMyMessage, isStatus = false) {
    const messagesContainer = document.querySelector("#messages");
    const message = document.createElement('div');
    
    if (isStatus) {
        message.classList.add("status-message");
        message.textContent = messageText;
    } else {
        message.classList.add("message");
        message.textContent = messageText;
        
        if (isMyMessage) {
            message.style.backgroundColor = "#256aff";
            message.style.color = "white";
            message.style.alignSelf = "flex-end";
        } else {
            message.style.backgroundColor = "#eee";
            message.style.color = "black";
            message.style.alignSelf = "flex-start";
        }
    }
    
    messagesContainer.appendChild(message);
    
    const chatBox = document.querySelector(".chat-box");
    chatBox.scrollTop = chatBox.scrollHeight;
}