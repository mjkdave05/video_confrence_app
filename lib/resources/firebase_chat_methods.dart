import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChatMethods {
  final DatabaseReference chatRef = FirebaseDatabase.instance
      .ref()
      .child('chats'); // Reference to Firebase 'chats' node
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance
  late IO.Socket socket;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance

  FirebaseChatMethods() {
    // Initialize Socket.IO
    socket = IO.io('https://scoket-server.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
  }

  // Listen for new messages from Socket.IO
  void listenForMessages(Function(Map<String, dynamic>) onMessageReceived) {
    socket.on('message', (data) {
      onMessageReceived({'message': data['message'], 'sender': data['sender']});
      _saveMessageToFirebase(data['message'],
          data['sender']); // Save to Firebase Realtime Database
      _saveMessageToFirestore(
          data['message'], data['sender']); // Save to Firestore
    });
  }

  // Send message through Socket.IO
  void sendMessage(String message) {
    String? currentUserId = _auth.currentUser?.uid;
    if (message.isNotEmpty && currentUserId != null) {
      socket.emit('message', {
        'message': message,
        'sender': currentUserId, // Send the current user's ID as the sender
      });
    }
  }

  // Cache and load old messages from Firebase
  Future<List<Map<String, dynamic>>> loadCachedMessages() async {
    DatabaseEvent event = await chatRef.once(); // Returns a DatabaseEvent
    DataSnapshot snapshot =
        event.snapshot; // Extract snapshot from DatabaseEvent
    List<Map<String, dynamic>> cachedMessages = [];

    if (snapshot.exists && snapshot.value != null) {
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

  // Save new message to Firebase Realtime Database
  void _saveMessageToFirebase(String message, String sender) {
    chatRef.push().set({'message': message, 'sender': sender});
  }

  // Save new message to Firestore
  void _saveMessageToFirestore(String message, String sender) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('chats')
        .add({
      'message': message,
      'sender': sender,
      'createdAt': DateTime.now(),
    });
  }

  // Clear all messages from Firestore
  Future<void> clearAllFirestoreMessages() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('chats')
        .get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Disconnect the socket when done
  void disconnect() {
    socket.disconnect();
  }
}
