import 'package:get/get.dart';

class VideoRoomController extends GetxController {
  final roomId = '482319'.obs;
  final isMicMuted = false.obs;
  final isCameraOff = false.obs;
  final participantCount = 2.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map && args.containsKey('roomId')) {
      roomId.value = args['roomId'].toString();
    }
  }

  void toggleMic() {
    isMicMuted.value = !isMicMuted.value;
  }

  void toggleCamera() {
    isCameraOff.value = !isCameraOff.value;
  }

  void leaveRoom() {
    Get.back();
  }
}
