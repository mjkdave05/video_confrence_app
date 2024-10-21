import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_confrence_app/resources/auth_methods.dart';
import 'package:video_confrence_app/resources/firestore_methods.dart';

class AgoraMeetMethods {
  final AuthMethods _authMethods = AuthMethods();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  late RtcEngine _engine;

  // Initialize Agora SDK and request necessary permissions
  Future<void> initializeAgoraEngine(
      {required ChannelProfileType channelProfile, required appId}) async {
    // Request permissions for microphone and camera
    await [Permission.microphone, Permission.camera].request();

    // Initialize the Agora engine
    _engine = await createAgoraRtcEngine(); // Replace with your Agora App ID
    await _engine.enableVideo();
    await _engine.startPreview();

    // Set event handlers for Agora events
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print(
              'Successfully joined channel: ${connection.channelId}, uid: ${connection.localUid}');
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print('Remote user joined with uid: $remoteUid');
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          print('Remote user left with uid: $remoteUid');
        },
      ),
    );
  }

  // Create and join an Agora meeting (channel)
  Future<void> createMeeting({
    required String testing,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String username = '',
  }) async {
    try {
      String name = username.isEmpty
          ? _authMethods.currentUser?.displayName ?? 'Guest'
          : username;

      // Initialize the Agora engine if not already initialized
      await initializeAgoraEngine(
        appId: '3e36dd4517154406b16857886d2d3ce3',
        channelProfile: ChannelProfileType.channelProfileCommunication,
      );

      // Set audio and video muting options
      await _engine.muteLocalAudioStream(isAudioMuted);
      await _engine.muteLocalVideoStream(isVideoMuted);

      // Join the Agora meeting (channel) without a token for testing
      await _engine.joinChannel(
        token:
            "007eJxTYGA37e9KFNhmnLymn2PpOua44zm9ifMOS+yaHbg6eXEv7xcFBuNUY7OUFBNTQ3NDUxMTA7MkQzMLU3MLC7MUoxTj5FTju2qi6Q2BjAy3C6cyMEIhiM/OUJJaXJKZl87AAAASJh7f", // Set to null for testing, replace with a token for production
        channelId: testing,
        uid: 0,
        options: const ChannelMediaOptions(
            // Automatically subscribe to all video streams
            autoSubscribeVideo: true,
            // Automatically subscribe to all audio streams
            autoSubscribeAudio: true,
            // Publish camera video
            publishCameraTrack: true,
            // Publish microphone audio
            publishMicrophoneTrack: true,
            // Set user role to clientRoleBroadcaster (broadcaster) or clientRoleAudience (audience)
            clientRoleType: ClientRoleType.clientRoleBroadcaster),
      );

      // Log the meeting to Firestore history
      _firestoreMethods.addToMeetingHistory(testing);
    } catch (error) {
      print("Error creating Agora meeting: $error");
    }
  }

  // Leave the Agora channel (meeting)
  Future<void> leaveMeeting() async {
    try {
      await _engine.leaveChannel();
      await _engine.release(); // Destroy Agora engine instance
    } catch (error) {
      print("Error leaving Agora meeting: $error");
    }
  }
}
