import 'package:flutter_project_architecture/features/home/view/home_screen.dart';
import 'package:flutter_project_architecture/features/room_setup/view/room_setup_screen.dart';
import 'package:flutter_project_architecture/features/video_room/view/video_room_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  //============= Home & Room Routes ==============
  static const String homeScreen = "/homeScreen";
  static const String roomSetupScreen = "/roomSetupScreen";
  static const String videoRoomScreen = "/videoRoomScreen";

  static List<GetPage> routes = [
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: roomSetupScreen, page: () => const RoomSetupScreen()),
    GetPage(name: videoRoomScreen, page: () => const VideoRoomScreen()),
  ];
}
