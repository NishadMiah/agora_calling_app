import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_const.dart';

class RoomSetupController extends GetxController {
  final isCreateMode = true.obs;
  final generatedRoomId = AppConstants.defaultRoomId.obs;
  late final TextEditingController joinRoomIdController;

  @override
  void onInit() {
    super.onInit();
    joinRoomIdController = TextEditingController(text: AppConstants.defaultRoomId);
    final args = Get.arguments;
    if (args != null && args is Map && args.containsKey('isCreate')) {
      isCreateMode.value = args['isCreate'] as bool;
    }
  }

  @override
  void onClose() {
    joinRoomIdController.dispose();
    super.onClose();
  }

  void copyRoomId() {
    Clipboard.setData(ClipboardData(text: generatedRoomId.value));
    Fluttertoast.showToast(
      msg: "Room ID copied to clipboard",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void startRoom() {
    Get.toNamed(
      AppRoutes.videoRoomScreen,
      arguments: {
        'roomId': generatedRoomId.value,
        'isHost': true,
      },
    );
  }

  void joinRoom() {
    final roomId = joinRoomIdController.text.trim();
    if (roomId.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter a Room ID",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    Get.toNamed(
      AppRoutes.videoRoomScreen,
      arguments: {
        'roomId': roomId,
        'isHost': false,
      },
    );
  }
}
