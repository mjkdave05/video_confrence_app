import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:firebase_database/firebase_database.dart';

class FirebaseChatMethods {
  final DatabaseReference chatRef =
      FirebaseDatabase.instance.ref().child('chats'); // Updated to ref()
  late IO.Socket socket;

  FirebaseChatMethods() {
    // Initialize Socket.IO
    socket = IO.io('https://your-chat-server.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
  }

  // Listen for new messages from Socket.IO
  void listenForMessages(Function(Map<String, dynamic>) onMessageReceived) {
    socket.on('message', (data) {
      onMessageReceived({'message': data['message'], 'sender': data['sender']});
      _saveMessageToFirebase(data['message'], data['sender']);
    });
  }

  // Send message through Socket.IO
  void sendMessage(String message) {
    if (message.isNotEmpty) {
      socket.emit('message', {'message': message, 'sender': 'user1'});
    }
  }

  // Cache and load old messages from Firebase
  Future<List<Map<String, dynamic>>> loadCachedMessages() async {
    DatabaseEvent event = await chatRef.once(); // Returns a DatabaseEvent
    DataSnapshot snapshot =
        event.snapshot; // Extract snapshot from DatabaseEvent
    List<Map<String, dynamic>> cachedMessages = [];

    if (snapshot.exists && snapshot.value != null) {
      // Ensure snapshot has data
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        cachedMessages.add({
          'message': value['message'],
          'sender': value['sender'],
        });
      });
    }

    return cachedMessages;
  }

  // Save new message to Firebase
  void _saveMessageToFirebase(String message, String sender) {
    chatRef.push().set({'message': message, 'sender': sender});
  }

  // Disconnect the socket when done
  void disconnect() {
    socket.disconnect();
  }
}
