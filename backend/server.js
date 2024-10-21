// server.js
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = new Server(server);

// Handle connection events
io.on('connection', (socket) => {
  console.log('a user connected: ', socket.id);

  // Listen for 'message' events from clients
  socket.on('message', (data) => {
    console.log('message received: ', data);

    // Broadcast the message to all other clients
    io.emit('message', data);
  });

  // Handle user disconnecting
  socket.on('disconnect', () => {
    console.log('user disconnected: ', socket.id);
  });
});

// Serve the app
app.get('/', (req, res) => {
  res.send("Socket.IO Chat Server is running...");
});

// Start the server
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
