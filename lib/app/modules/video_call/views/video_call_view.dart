import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/video_call_controller.dart';

class VideoCallView extends GetView<VideoCallController> {
  const VideoCallView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Obx(() {
          return Text(
              controller.isTeacher.value ? 'Teacher View' : 'Student View');
        }),
      ),
      body: Stack(
        children: [
          // Display Remote Users in a Grid
          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(
                  top: 120.0), // Leaves space for local video
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Display videos in a grid (2 per row)
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                itemCount: controller.remoteUids.value.length,
                itemBuilder: (context, index) {
                  return Expanded(
                    child: AgoraVideoView(
                      onAgoraVideoViewCreated: (viewId) {
                        debugPrint("onAgoraVideoViewCreated: $viewId");
                      },
                      controller: VideoViewController.remote(
                        rtcEngine: controller.engine,
                        canvas: VideoCanvas(
                            uid: controller.remoteUids.value[index]),
                        connection:
                            RtcConnection(channelId: controller.channelName),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          // Local Video for Teacher (Top-Right) and Students (Top)
          Align(
            alignment: controller.isTeacher.value
                ? Alignment.topRight
                : Alignment.topRight,
            child: SizedBox(
              width: 120,
              height: 120,
              child: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: controller.engine,
                  canvas: const VideoCanvas(uid: 0), // Local user
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
