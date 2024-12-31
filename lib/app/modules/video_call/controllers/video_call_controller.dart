import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallController extends GetxController {
  // ========================= arguments =======================================
  Rx<String?> role = Rx(null);

  // ========================= agora config ====================================
  final String appId =
      "3219b2cd9f8e4e618a6639f63b17035d"; // Replace with your Agora App ID
  final String channelName = "classroom";
  final String token =
      "007eJxTYHBl7z/2/LNZQbreWo80wYDCL+vvx8pX9ecb5EbEh5r8nKzAYGxkaJlklJximWaRapJqZmiRaGZmbJlmZpxkaG5gbJoyp6E4vSGQkSHS2Z+BEQpBfE6G5JzE4uKi/PxcBgYAitUf1A=="; // Replace with your Agora Token

  // ========================== agora variable =================================
  late RtcEngine engine;
  Rx<List<int>> remoteUids = Rx([]);
  Rx<bool> isTeacher = false.obs;

  Rx<int?> userId = Rx(null);
  Rx<bool> localUserJoined = false.obs;

//   Future<void> initAgora() async {
//     // ========================= Request Permissions ====================================
//     await [Permission.microphone, Permission.camera].request();

//     // Initialize Agora Engine
//     // _engine = createAgoraRtcEngine();
//     // engine = createAgoraRtcEngine();
//     await engine.initialize(RtcEngineContext(appId: appId));

//     // Set event handlers
//     engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onUserJoined: (RtcConnection connection, int elapsed, int uid) {
//           remoteUids.value.add(uid);
//           remoteUids.refresh();
//         },
//         onUserOffline: (RtcConnection connection, int uid,
//             UserOfflineReasonType userOfflineReasonType) {
//           remoteUids.value.remove(uid);
//           remoteUids.refresh();
//         },
//       ),
//     );

//     // Set channel profile and role
//     await engine
//         .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);

//     if (isTeacher.value) {
//       await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
//     } else {
//       await engine.setClientRole(role: ClientRoleType.clientRoleAudience);
//     }

//     // Enable the video module
//     await engine.enableVideo();
// // Enable local video preview
//     await engine.startPreview();

//     // Join the channel
//     await engine.joinChannel(
//       token: token,
//       channelId: channelName,
//       uid: 0,
//       options: const ChannelMediaOptions(
//         // Automatically subscribe to all video streams
//         autoSubscribeVideo: true,
//         // Automatically subscribe to all audio streams
//         autoSubscribeAudio: true,
//         // Publish camera video
//         publishCameraTrack: true,
//         // Publish microphone audio
//         publishMicrophoneTrack: true,
//       ),
//     );
//   }

  Future<void> initAgora() async {
    // Get microphone and camera permissions
    await [Permission.microphone, Permission.camera].request();

    // Create RtcEngine instance
    engine = createAgoraRtcEngine();
    // Initialize RtcEngine and set the channel profile to live broadcasting
    await engine.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    // Add an event handler
    engine.registerEventHandler(
      RtcEngineEventHandler(
        // Occurs when the local user joins the channel successfully
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          localUserJoined.value = true;
        },
        // Occurs when a remote user join the channel
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          userId.value = remoteUid;
        },
        // Occurs when a remote user leaves the channel
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          userId.value = null;
        },
      ),
    );
    // Enable the video module
    await engine.enableVideo();
    // Enable local video preview
    await engine.startPreview();
    // Join a channel using a temporary token and channel name
    await engine.joinChannel(
      token: token,
      channelId: channelName,
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
      uid:
          0, // When you set uid to 0, a user name is randomly generated by the engine
    );
  }

  @override
  void onInit() {
    super.onInit();
    role.value = Get.arguments as String;
    isTeacher.value = (role.value == 'Teacher');
    engine = createAgoraRtcEngine();
    initAgora();
  }

  @override
  void onClose() {
    super.onClose();
    engine.leaveChannel();
    engine.release();
  }
}
