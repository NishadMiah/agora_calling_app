import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utils/app_const.dart';

class VideoRoomController extends GetxController {
  final roomId = '482319'.obs;
  final isMicMuted = false.obs;
  final isCameraOff = false.obs;
  final participantCount = 1.obs;
  final isJoined = false.obs;
  final remoteUid = RxnInt();

  RtcEngine? engine;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map && args.containsKey('roomId')) {
      roomId.value = args['roomId'].toString();
    }
    initAgora();
  }

  Future<void> initAgora() async {
    try {
      // 1. Request microphone & camera permissions
      await [Permission.microphone, Permission.camera].request();

      if (AppConstants.agoraAppId == "YOUR_AGORA_APP_ID" ||
          AppConstants.agoraAppId.isEmpty) {
        debugPrint("Agora App ID is not set. Using preview mode.");
        participantCount.value = 2;
        return;
      }

      // 2. Create RTC Engine instance
      engine = createAgoraRtcEngine();
      await engine!.initialize(
        const RtcEngineContext(
          appId: AppConstants.agoraAppId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            isJoined.value = true;
            participantCount.value = 1;
            debugPrint("Successfully joined channel: ${connection.channelId}");
          },
          onUserJoined: (RtcConnection connection, int uid, int elapsed) {
            remoteUid.value = uid;
            participantCount.value = 2;
            debugPrint("Remote user joined: $uid");
          },
          onUserOffline: (
            RtcConnection connection,
            int uid,
            UserOfflineReasonType reason,
          ) {
            remoteUid.value = null;
            participantCount.value = 1;
            debugPrint("Remote user left: $uid");
          },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            isJoined.value = false;
            remoteUid.value = null;
          },
        ),
      );

      await engine!.enableVideo();
      await engine!.startPreview();

      await engine!.joinChannel(
        token: AppConstants.agoraToken,
        channelId: roomId.value,
        uid: 0,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );
    } catch (e) {
      debugPrint("Agora Init Error: $e");
    }
  }

  Future<void> toggleMic() async {
    isMicMuted.value = !isMicMuted.value;
    await engine?.muteLocalAudioStream(isMicMuted.value);
  }

  Future<void> toggleCamera() async {
    isCameraOff.value = !isCameraOff.value;
    await engine?.muteLocalVideoStream(isCameraOff.value);
  }

  Future<void> leaveRoom() async {
    try {
      await engine?.leaveChannel();
    } catch (e) {
      debugPrint("Leave channel error: $e");
    }
    Get.back();
  }

  @override
  void onClose() {
    engine?.leaveChannel();
    engine?.release();
    super.onClose();
  }
}
