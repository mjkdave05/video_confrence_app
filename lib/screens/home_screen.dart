import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  void _loadUserDetails() {
    // Get the current signed-in user from FirebaseAuth
    User? currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // If user is signed in, display the username and profile photo
        title: _user != null
            ? Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_user!.photoURL ??
                        'https://via.placeholder.com/150'), // Placeholder image if no profile picture
                  ),
                  const SizedBox(width: 10), // Space between image and username
                  Text(
                    _user!.displayName ?? 'Guest',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              )
            : const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to the Home Screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
