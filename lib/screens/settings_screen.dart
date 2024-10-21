import 'package:flutter/material.dart';
import 'package:video_confrence_app/services/dark_mode_service.dart';
import 'package:video_confrence_app/services/location_services.dart';
import 'package:video_confrence_app/services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _autoUpdate = false;
  bool _locationAccess = true;
  bool _notifications = false;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Dark Mode Toggle
              _buildSettingTile(
                context,
                title: 'Dark Mode',
                subtitle: 'Enable or disable dark theme',
                icon: Icons.dark_mode,
                toggleValue: _darkMode,
                onChanged: (value) {
                  setState(() {
                    _darkMode = value;
                    // Implement dark mode toggle logic
                    // ThemeService.toggleTheme();
                  });
                },
              ),

              // Notifications Toggle
              _buildSettingTile(
                context,
                title: 'Notifications',
                subtitle: 'Enable or disable app notifications',
                icon: Icons.notifications,
                toggleValue: _notifications,
                onChanged: (value) {
                  setState(() {
                    _notifications = value;
                    // Handle notifications toggle
                    if (value) {
                      NotificationService().enableNotifications();
                    } else {
                      NotificationService().disableNotifications();
                    }
                  });
                },
              ),

              // Auto-update Toggle
              _buildSettingTile(
                context,
                title: 'Auto-Update',
                subtitle: 'Enable or disable automatic updates',
                icon: Icons.update,
                toggleValue: _autoUpdate,
                onChanged: (value) {
                  setState(() {
                    _autoUpdate = value;
                    // Handle auto-update logic
                  });
                },
              ),

              // Location Access Toggle
              _buildSettingTile(
                context,
                title: 'Location Access',
                subtitle: 'Allow access to your location',
                icon: Icons.location_on,
                toggleValue: _locationAccess,
                onChanged: (value) {
                  setState(() {
                    _locationAccess = value;
                    // Handle location access logic
                    if (value) {
                      LocationService().enableLocationAccess(context);
                    } else {
                      LocationService().disableLocationAccess(context);
                    }
                  });
                },
              ),

              const SizedBox(height: 20),

              // Account Settings
              _buildSettingsCategory('Account Settings'),
              _buildSettingsTile(
                context,
                title: 'Manage Account',
                icon: Icons.account_circle,
                onTap: () {
                  // Navigate to account management screen
                },
              ),
              _buildSettingsTile(
                context,
                title: 'Privacy & Security',
                icon: Icons.privacy_tip,
                onTap: () {
                  // Navigate to privacy settings
                },
              ),

              const SizedBox(height: 20),

              // App Settings
              _buildSettingsCategory('App Settings'),
              _buildSettingsTile(
                context,
                title: 'Language',
                icon: Icons.language,
                onTap: () {
                  // Navigate to language settings
                },
              ),
              _buildSettingsTile(
                context,
                title: 'About',
                icon: Icons.info_outline,
                onTap: () {
                  // Navigate to about page
                },
              ),
              _buildSettingsTile(
                context,
                title: 'Terms & Conditions',
                icon: Icons.article,
                onTap: () {
                  // Navigate to terms and conditions
                },
              ),
              _buildSettingsTile(
                context,
                title: 'Log Out',
                icon: Icons.logout,
                onTap: () {
                  // Handle log out logic
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for each setting with toggle
  Widget _buildSettingTile(BuildContext context,
      {required String title,
      required String subtitle,
      required IconData icon,
      required bool toggleValue,
      required Function(bool) onChanged}) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: toggleValue,
      activeColor: Colors.blue, // Set active color for the toggle switch
      onChanged: onChanged,
      secondary: Icon(
        icon,
        color: toggleValue
            ? Colors.blue
            : Colors.grey, // Change icon color based on toggle state
      ),
    );
  }

  // Widget for category headings
  Widget _buildSettingsCategory(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        category,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  // Widget for each non-toggle setting
  Widget _buildSettingsTile(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
