import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utils/app_const.dart';

class VideoRoomController extends GetxController {
  final roomId = AppConstants.defaultRoomId.obs;
  final isMicMuted = false.obs;
  final isCameraOff = false.obs;
  final isSpeakerOn = true.obs;
  final participantCount = 1.obs;
  final isJoined = false.obs;
  final isEngineReady = false.obs;
  final isRemoteVideoMuted = false.obs;
  final isRemoteAudioMuted = false.obs;
  final remoteUsers = <int>[].obs;
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
      final statuses = await [
        Permission.microphone,
        Permission.camera,
      ].request();

      if (statuses[Permission.camera] != PermissionStatus.granted ||
          statuses[Permission.microphone] != PermissionStatus.granted) {
        debugPrint("Camera or Microphone permission not granted");
      }

      final appId = AppConstants.agoraAppId.trim();
      if (appId.isEmpty) {
        debugPrint("Agora App ID is not set. Running in demo mode.");
        participantCount.value = 2;
        return;
      }

      // 2. Create and initialize RTC Engine
      engine = createAgoraRtcEngine();
      await engine!.initialize(
        RtcEngineContext(
          appId: appId,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );

      // 3. Register Event Handlers
      engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            isJoined.value = true;
            participantCount.value = 1 + remoteUsers.length;
            debugPrint("Successfully joined channel: ${connection.channelId}");
            try {
              engine?.setEnableSpeakerphone(isSpeakerOn.value);
            } catch (e) {
              debugPrint("Speakerphone set error: $e");
            }
          },
          onUserJoined: (RtcConnection connection, int uid, int elapsed) {
            if (!remoteUsers.contains(uid)) {
              remoteUsers.add(uid);
              remoteUid.value = uid;
            }
            isRemoteVideoMuted.value = false;
            participantCount.value = 1 + remoteUsers.length;
            debugPrint("Remote user joined: $uid");
          },
          onUserMuteVideo: (RtcConnection connection, int uid, bool muted) {
            if (uid == remoteUid.value) {
              isRemoteVideoMuted.value = muted;
            }
            debugPrint("User $uid muted video: $muted");
          },
          onUserMuteAudio: (RtcConnection connection, int uid, bool muted) {
            if (uid == remoteUid.value) {
              isRemoteAudioMuted.value = muted;
            }
            debugPrint("User $uid muted audio: $muted");
          },
          onUserOffline: (
            RtcConnection connection,
            int uid,
            UserOfflineReasonType reason,
          ) {
            remoteUsers.remove(uid);
            remoteUid.value = remoteUsers.isNotEmpty ? remoteUsers.first : null;
            isRemoteVideoMuted.value = false;
            participantCount.value = 1 + remoteUsers.length;
            debugPrint("Remote user left: $uid");
          },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            isJoined.value = false;
            remoteUsers.clear();
            remoteUid.value = null;
            isRemoteVideoMuted.value = false;
            participantCount.value = 1;
          },
          onError: (ErrorCodeType err, String msg) {
            debugPrint("Agora error: $err, $msg");
          },
        ),
      );

      // 4. Setup Audio & Video Engine Configuration
      await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await engine!.enableVideo();
      await engine!.enableAudio();
      await engine!.enableLocalVideo(true);
      await engine!.enableLocalAudio(true);
      
      // Ensure default Audio Route is Speakerphone
      await engine!.setDefaultAudioRouteToSpeakerphone(true);
      await engine!.adjustRecordingSignalVolume(100);
      await engine!.adjustPlaybackSignalVolume(100);

      await engine!.startPreview();
      isEngineReady.value = true;

      // 5. Join Channel
      await engine!.joinChannel(
        token: AppConstants.agoraToken.trim(),
        channelId: roomId.value.trim(),
        uid: 0,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
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
    await engine?.enableLocalVideo(!isCameraOff.value);
  }

  Future<void> switchCamera() async {
    await engine?.switchCamera();
  }

  Future<void> toggleSpeaker() async {
    isSpeakerOn.value = !isSpeakerOn.value;
    await engine?.setEnableSpeakerphone(isSpeakerOn.value);
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
