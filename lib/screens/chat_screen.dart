import 'package:flutter/material.dart';
import 'package:video_confrence_app/resources/firebase_chat_methods.dart'; // Import your FirebaseChatMethods

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseChatMethods _chatMethods =
      FirebaseChatMethods(); // Initialize FirebaseChatMethods
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();

    // Load cached messages
    _chatMethods.loadCachedMessages().then((cachedMessages) {
      setState(() {
        messages = cachedMessages;
      });
    });

    // Listen for new messages
    _chatMethods.listenForMessages((messageData) {
      setState(() {
        messages.add(messageData);
      });
    });
  }

  // Send message function
  void _sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _chatMethods.sendMessage(message);
      setState(() {
        messages.add({'message': message, 'sender': 'user1'});
      });
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _chatMethods.disconnect(); // Disconnect socket when leaving screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal, // Sleek app bar design
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageTile(
                    messages[index]['message'], messages[index]['sender']);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Message Tile Widget
  Widget _buildMessageTile(String message, String sender) {
    bool isMe =
        sender == 'user1'; // Check if the message is sent by the current user
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isMe ? Colors.tealAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: isMe ? Colors.black : Colors.black87,
          ),
        ),
      ),
    );
  }

  // Message Input Widget
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Enter your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.teal,
            radius: 25,
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
