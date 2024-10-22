import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_confrence_app/screens/contacts_screen.dart';
import 'package:video_confrence_app/screens/history_meeting_screen.dart';
import 'package:video_confrence_app/screens/meeting_screen.dart';
import 'package:video_confrence_app/screens/onboarding.dart'; // Import the OnboardingScreen
import 'package:video_confrence_app/screens/settings_screen.dart';
import '../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;
  int _page = 0;

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

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  // Method to log out the user
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OnboardingScreen()), // Navigate to Onboarding after logout
      (Route<dynamic> route) => false, // Remove all routes from the stack
    );
  }

  List<Widget> pages = [
    MeetingScreen(),
    const HistoryMeetingScreen(),
    const ContactsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: _user?.photoURL != null
                    ? NetworkImage(_user!.photoURL!)
                    : const AssetImage('assets/default_avatar.png')
                        as ImageProvider, // Default avatar if no photoURL
                radius: 20,
              ),
              const SizedBox(width: 10),
              Text(
                _user?.displayName ?? 'User', // Display name or 'User' if null
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout, // Call the logout method
              tooltip: 'Logout',
            ),
          ],
        ),
        body: pages[_page],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: footerColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          onTap: onPageChanged,
          currentIndex: _page,
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: 14,
          selectedFontSize: 14,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(
                    top: 8.0), // Add space at the top of the icon
                child: Icon(Icons.comment_bank),
              ),
              label: 'conference',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(
                    top: 8.0), // Add space at the top of the icon
                child: Icon(Icons.lock_clock),
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(
                    top: 8.0), // Add space at the top of the icon
                child: Icon(Icons.person_outline),
              ),
              label: 'Contacts',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(
                    top: 8.0), // Add space at the top of the icon
                child: Icon(Icons.settings_outlined),
              ),
              label: 'Settings',
            ),
          ],
          showUnselectedLabels: true,
          selectedIconTheme: IconThemeData(size: 30),
          unselectedIconTheme: IconThemeData(size: 24),
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          elevation: 8,
        ));
  }
}
