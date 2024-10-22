import 'package:flutter/material.dart';

class ChatUI extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final TextEditingController messageController;
  final Function onSendMessage;

  const ChatUI({
    Key? key,
    required this.messages,
    required this.messageController,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {
              // Handle video call icon press
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // Handle voice call icon press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message['sender'] == 'me'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message['sender'] == 'me'
                          ? Colors.blue.shade300
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['message'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Sent by: ${message['sender']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.emoji_emotions_outlined),
                            onPressed: () {
                              // Handle emoji picker
                            },
                          ),
                          Expanded(
                            child: TextField(
                              controller: messageController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              // Show options for gallery, documents, audio, location, camera, and poll
                              _showAttachmentOptions(context);
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.send),
                              color: Colors.white,
                              onPressed: () => onSendMessage(),
                              padding: EdgeInsets.zero,
                              iconSize: 30,
                              constraints: BoxConstraints(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Space under the message features
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GridView.count(
          crossAxisCount: 4,
          children: [
            _buildOptionItem(Icons.photo, 'Gallery', () {
              // Handle gallery option
            }),
            _buildOptionItem(Icons.document_scanner, 'Documents', () {
              // Handle documents option
            }),
            _buildOptionItem(Icons.audiotrack, 'Audio', () {
              // Handle audio option
            }),
            _buildOptionItem(Icons.location_on, 'Location', () {
              // Handle location option
            }),
            _buildOptionItem(Icons.camera_alt, 'Camera', () {
              // Handle camera option
            }),
            _buildOptionItem(Icons.poll, 'Poll', () {
              // Handle poll option
            }),
          ],
        );
      },
    );
  }

  Widget _buildOptionItem(IconData icon, String label, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
