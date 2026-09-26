import 'package:flutter_project_architecture/features/home/view/home_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
    //============= Home ==============
  static const String homeScreen = "/homeScreen";

  static List<GetPage> routes = [
    //============= Home ==============
    GetPage(name: homeScreen, page: () => const HomeScreen()),
  
  ];
}
