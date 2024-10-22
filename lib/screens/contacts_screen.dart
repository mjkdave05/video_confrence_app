import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void chatScreen(BuildContext context) {
    Navigator.pushNamed(context, "/chat");
  }

  void _fetchUsers() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      List<Map<String, dynamic>> users = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'uid': doc.id,
          'username': data['username'] ?? 'Unknown User',
          'email': data['email'] ?? 'No email provided',
          'profilePhoto': data['profilePhoto'] ?? '',
          'status': data['status'] ?? 'offline',
        };
      }).toList();

      setState(() {
        _allUsers = users;
        _filteredUsers = users;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void _showUserOptions(BuildContext context, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(user['username'],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('UID: ${user['uid']}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  print("Message button pressed"); // Debug statement
                  chatScreen(context); // Navigate to chat
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: const Text('Message'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Add to Contacts'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: _filteredUsers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user['profilePhoto'].isNotEmpty
                        ? NetworkImage(user['profilePhoto'])
                        : null,
                    child: user['profilePhoto'].isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(user['username']),
                  subtitle:
                      Text(user['status'] == 'online' ? 'Online' : 'Offline'),
                  trailing: Icon(
                    Icons.circle,
                    color:
                        user['status'] == 'online' ? Colors.green : Colors.red,
                    size: 10,
                  ),
                  onTap: () => _showUserOptions(context, user),
                );
              },
            ),
    );
  }
}
