import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_confrence_app/utils/colors.dart';
import 'package:video_confrence_app/widgets/home_meeting_button.dart';
import 'package:video_confrence_app/resources/agora_meet_methods.dart'; // Refactored Agora methods

class MeetingScreen extends StatelessWidget {
  MeetingScreen({Key? key}) : super(key: key);

  final AgoraMeetMethods _agoraMeetMethods = AgoraMeetMethods();

  // Create a new Agora meeting
  Future<void> createNewMeeting() async {
    var random = Random();
    String testing = (random.nextInt(10000000) + 10000000).toString();
    await _agoraMeetMethods.createMeeting(
      testing: testing,
      isAudioMuted: true,
      isVideoMuted: true,
    );
  }

  void joinMeeting(BuildContext context) {
    Navigator.pushNamed(context, '/video-call');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Background color for a modern look
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the main content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container for title
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Meet & Chat',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20), // Space between title and image
            // Image widget for meeting illustration
            Image.asset(
              'assets/images/home1.png', // Replace with your image path
              height: MediaQuery.of(context).size.height *
                  0.3, // Use 40% of the screen height
              width: double.infinity, // Full width
              fit: BoxFit.contain, // Keep the aspect ratio
            ),

            const SizedBox(height: 16), // Space between image and text
            const Text(
              'Create/Join Meetings with just a click!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xDD818080), // Subtle text color
              ),
            ),
            const SizedBox(height: 32), // Space before buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HomeMeetingButton(
                  onPressed: createNewMeeting,
                  text: 'New Meeting',
                  icon: Icons.videocam,
                ),
                HomeMeetingButton(
                  onPressed: () => joinMeeting(context),
                  text: 'Join Meeting',
                  icon: Icons.add_box_rounded,
                ),
                HomeMeetingButton(
                  onPressed: () {},
                  text: 'Schedule',
                  icon: Icons.calendar_today,
                ),
                HomeMeetingButton(
                  onPressed: () {},
                  text: 'Share Screen',
                  icon: Icons.arrow_upward_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
