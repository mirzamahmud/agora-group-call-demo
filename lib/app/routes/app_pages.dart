import 'package:get/get.dart';
import '../modules/role_selection/bindings/role_selection_binding.dart';
import '../modules/role_selection/views/role_selection_view.dart';
import '../modules/video_call/bindings/video_call_binding.dart';
import '../modules/video_call/views/video_call_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ROLE_SELECTION;

  static final routes = [
    GetPage(
      name: _Paths.ROLE_SELECTION,
      page: () => const RoleSelectionView(),
      binding: RoleSelectionBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_CALL,
      page: () => const VideoCallView(),
      binding: VideoCallBinding(),
    ),
  ];
}
