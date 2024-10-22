import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_confrence_app/utils/pop_up.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get meetings history
  Stream<QuerySnapshot<Map<String, dynamic>>> get meetingsHistory => _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('meetings')
      .snapshots();

  // Add to meeting history
  void addToMeetingHistory(String meetingName) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('meetings')
          .add({
        'meetingName': meetingName,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  // Delete meeting
  Future<void> deleteMeeting(BuildContext context, String meetingId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('meetings')
          .doc(meetingId)
          .delete();
    } catch (e) {
      PopupService.showPopup(context, 'Error deleting meeting: $e');
    }
  }

  // Clear all meetings
  Future<void> clearAllMeetings(BuildContext context) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('meetings')
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      PopupService.showPopup(context, 'Error clearing all meetings: $e');
    }
  }

  // Get chats
  Stream<QuerySnapshot<Map<String, dynamic>>> get chatsHistory => _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('chats')
      .snapshots();

  // Add a new chat message
  void addChatMessage(String message) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('chats')
          .add({
        'message': message,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  // Delete chat message
  Future<void> deleteChatMessage(BuildContext context, String chatId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('chats')
          .doc(chatId)
          .delete();
    } catch (e) {
      PopupService.showPopup(context, 'Error deleting chat message: $e');
    }
  }

  // Clear all chat messages
  Future<void> clearAllChats(BuildContext context) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('chats')
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      PopupService.showPopup(context, 'Error clearing all chats: $e');
    }
  }
}
