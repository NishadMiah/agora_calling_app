import 'package:get/get.dart';
import '../../../core/app_routes/app_routes.dart';

class HomeController extends GetxController {
  void navigateToCreateRoom() {
    Get.toNamed(
      AppRoutes.roomSetupScreen,
      arguments: {'isCreate': true},
    );
  }

  void navigateToJoinRoom() {
    Get.toNamed(
      AppRoutes.roomSetupScreen,
      arguments: {'isCreate': false},
    );
  }
}
