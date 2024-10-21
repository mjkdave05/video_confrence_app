import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_confrence_app/resources/agora_meet_methods.dart';
import 'package:video_confrence_app/utils/colors.dart';
import 'package:video_confrence_app/widgets/meeting_option.dart';
import 'package:video_confrence_app/resources/auth_methods.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final AuthMethods _authMethods = AuthMethods();
  late TextEditingController meetingIdController;
  late TextEditingController nameController;
  final AgoraMeetMethods _agoraMeetMethods = AgoraMeetMethods();
  bool isAudioMuted = true;
  bool isVideoMuted = true;

  @override
  void initState() {
    super.initState();
    meetingIdController = TextEditingController();
    nameController = TextEditingController(
      text: _authMethods.currentUser?.displayName ?? '',
    );
  }

  @override
  void dispose() {
    meetingIdController.dispose();
    nameController.dispose();
    _agoraMeetMethods.leaveMeeting();
    super.dispose();
  }

  _joinMeeting() async {
    var microphoneStatus = await Permission.microphone.request();
    var cameraStatus = await Permission.camera.request();

    if (microphoneStatus.isGranted && cameraStatus.isGranted) {
      _agoraMeetMethods.createMeeting(
        testing: meetingIdController.text,
        isAudioMuted: isAudioMuted,
        isVideoMuted: isVideoMuted,
        username: nameController.text,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please grant camera and microphone permissions'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text(
          'Join a Meeting',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              controller: meetingIdController,
              hintText: 'Room ID',
              icon: Icons.meeting_room,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: nameController,
              hintText: 'Name',
              icon: Icons.person,
            ),
            const SizedBox(height: 20),
            _buildJoinButton(),
            const SizedBox(height: 20),
            MeetingOption(
              text: 'Mute Audio',
              isMute: isAudioMuted,
              onChange: onAudioMuted,
            ),
            MeetingOption(
              text: 'Turn Off My Video',
              isMute: isVideoMuted,
              onChange: onVideoMuted,
            ),
          ],
        ),
      ),
    );
  }

  // TextField with an icon
  Widget _buildTextField({
    required TextEditingController controller, // Correctly defined parameter
    required String hintText, // Correctly defined parameter
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      maxLines: 1,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        fillColor: secondaryBackgroundColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  // Join button with modern style
  Widget _buildJoinButton() {
    return GestureDetector(
      onTap: _joinMeeting,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.blue, // Use your primary color
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Join',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Handle audio mute toggle
  onAudioMuted(bool val) {
    setState(() {
      isAudioMuted = val;
    });
  }

  // Handle video mute toggle
  onVideoMuted(bool val) {
    setState(() {
      isVideoMuted = val;
    });
  }
}
