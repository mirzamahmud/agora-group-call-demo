import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/video_call_controller.dart';

class VideoCallView extends GetView<VideoCallController> {
  const VideoCallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Obx(() {
          if (controller.isTeacher.value) {
            return Text('Teacher View');
          } else {
            return Text('Student View');
          }
        }),
      ),
      body: Stack(
        children: [
          Obx(() {
            return Center(
              child: _remoteVideo(),
            );
          }),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Obx(() {
                return Center(
                  child: controller.localUserJoined.value
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            useFlutterTexture: true,
                            rtcEngine: controller.engine,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        )
                      : const CircularProgressIndicator(),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to display remote video
  Widget _remoteVideo() {
    if (controller.userId.value != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          useFlutterTexture: true,
          rtcEngine: controller.engine,
          canvas: VideoCanvas(uid: controller.userId.value),
          connection: RtcConnection(channelId: controller.channelName),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
