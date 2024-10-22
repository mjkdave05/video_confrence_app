import 'package:flutter/material.dart';
import 'package:video_confrence_app/resources/firebase_chat_methods.dart';
import 'package:video_confrence_app/services/chat_ui.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseChatMethods _firebaseChatMethods = FirebaseChatMethods();
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadCachedMessages();
    _firebaseChatMethods.listenForMessages(_onMessageReceived);
  }

  void _loadCachedMessages() async {
    List<Map<String, dynamic>> cachedMessages =
        await _firebaseChatMethods.loadCachedMessages();
    setState(() {
      _messages = cachedMessages;
    });
  }

  void _onMessageReceived(Map<String, dynamic> message) {
    setState(() {
      _messages.add(message);
    });
  }

  void _sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _firebaseChatMethods.sendMessage(message);
      _messageController.clear();
      _onMessageReceived(
          {'message': message, 'sender': 'me'}); // Show sent message
    }
  }

  @override
  void dispose() {
    _firebaseChatMethods.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatUI(
      messages: _messages,
      messageController: _messageController,
      onSendMessage: _sendMessage,
    );
  }
}
