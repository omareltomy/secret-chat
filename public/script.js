document.addEventListener('DOMContentLoaded', () => {
    const form = document.querySelector('#my-form');
    form.addEventListener('submit', (e) => {
        e.preventDefault();
        const message = e.target.elements[0].value;
        const spaces = message.match(/\s/g);
        console.log(spaces)
        if (spaces.length >= message.length) {
            e.target.elements[0].value = "";
            return
        }
        socket.emit('message-from-client-to-server', message);
         e.target.elements[0].value = "";
    });
});
const socket = io()
let myId = "";
socket.on("uid", id =>{
    myId = id
})
socket.on('message-to-all', (data) => {
    console.log(data)
    const messagesContainer = document.querySelector("#messages");
    const message = document.createElement('p');
    message.classList.add("message")
    if (data.sender === myId) {
        message.style.backgroundColor = "blue";
        message.style.color = "white";
        message.style.textAlign = "right";
        message.style.justifySelf = "flex-end";

    } else {
        message.style.backgroundColor = "#eee";
        message.style.color = "black";
        message.style.textAlign = "left";
        message.style.justifySelf = "flex-start";

    }
    message.textContent = data.message;
    messagesContainer.appendChild(message)
    const chatBox = document.querySelector(".chat-box");
    chatBox.scrollTop = chatBox.scrollHeight;
})

