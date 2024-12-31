import 'package:agora_group_call_demo/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/role_selection_controller.dart';

class RoleSelectionView extends GetView<RoleSelectionController> {
  const RoleSelectionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Role"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.VIDEO_CALL, arguments: 'Teacher');
              },
              child: const Text("Join as Teacher"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.VIDEO_CALL, arguments: 'Student');
              },
              child: const Text("Join as Student"),
            ),
          ],
        ),
      ),
    );
  }
}
