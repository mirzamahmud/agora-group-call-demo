import 'package:agora_group_call_demo/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AgoraGroupCallDemo extends StatelessWidget {
  const AgoraGroupCallDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Agora Group Call Demo",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
