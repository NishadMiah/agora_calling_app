import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_token_generator/agora_token_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../utils/app_const.dart';

class VideoRoomController extends GetxController {
  final roomId = ''.obs;
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

  /// Generates an Agora RTC token locally using App Certificate.
  /// ⚠️ In production, generate tokens on a secure backend server.
  String _generateToken({required String channelName, required int uid}) {
    final appCertificate = AppConstants.agoraAppCertificate;

    // If no App Certificate is configured, return empty string
    // (works only if Agora project is in Testing/App-ID-Only mode)
    if (appCertificate == 'YOUR_APP_CERTIFICATE_HERE' ||
        appCertificate.isEmpty) {
      debugPrint(
        '[Agora] No App Certificate set — joining without token. '
        'Make sure your Agora project is in Testing Mode.',
      );
      return '';
    }

    try {
      final token = RtcTokenBuilder.buildTokenWithUid(
        appId: AppConstants.agoraAppId,
        appCertificate: appCertificate,
        channelName: channelName,
        uid: uid,
        tokenExpireSeconds: AppConstants.agoraTokenExpirySeconds,
      );

      debugPrint('[Agora] Token generated successfully for channel: $channelName');
      return token;
    } catch (e) {
      debugPrint('[Agora] Token generation failed: $e');
      return '';
    }
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

      // 2. Generate token locally
      final token = _generateToken(channelName: roomId.value, uid: 0);

      // 3. Create and initialize RTC Engine
      engine = createAgoraRtcEngine();
      await engine!.initialize(
        RtcEngineContext(
          appId: appId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      // 4. Register Event Handlers
      engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            isJoined.value = true;
            participantCount.value = 1 + remoteUsers.length;
            debugPrint(
              "[Agora] Joined channel: ${connection.channelId}, uid: ${connection.localUid}",
            );
            try {
              engine?.setEnableSpeakerphone(isSpeakerOn.value);
            } catch (e) {
              debugPrint("[Agora] Speakerphone set error: $e");
            }
          },
          onUserJoined: (RtcConnection connection, int uid, int elapsed) {
            if (!remoteUsers.contains(uid)) {
              remoteUsers.add(uid);
              remoteUid.value = uid;
            }
            isRemoteVideoMuted.value = false;
            participantCount.value = 1 + remoteUsers.length;
            debugPrint("[Agora] Remote user joined: $uid");
          },
          onUserMuteVideo: (RtcConnection connection, int uid, bool muted) {
            if (uid == remoteUid.value) {
              isRemoteVideoMuted.value = muted;
            }
            debugPrint("[Agora] User $uid muted video: $muted");
          },
          onUserMuteAudio: (RtcConnection connection, int uid, bool muted) {
            if (uid == remoteUid.value) {
              isRemoteAudioMuted.value = muted;
            }
            debugPrint("[Agora] User $uid muted audio: $muted");
          },
          onUserOffline: (
            RtcConnection connection,
            int uid,
            UserOfflineReasonType reason,
          ) {
            remoteUsers.remove(uid);
            remoteUid.value =
                remoteUsers.isNotEmpty ? remoteUsers.first : null;
            isRemoteVideoMuted.value = false;
            participantCount.value = 1 + remoteUsers.length;
            debugPrint("[Agora] Remote user left: $uid");
          },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            isJoined.value = false;
            remoteUsers.clear();
            remoteUid.value = null;
            isRemoteVideoMuted.value = false;
            participantCount.value = 1;
          },
          onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
            // Regenerate & renew the token before it expires
            debugPrint('[Agora] Token will expire soon. Renewing...');
            final newToken =
                _generateToken(channelName: roomId.value, uid: 0);
            if (newToken.isNotEmpty) {
              engine?.renewToken(newToken);
            }
          },
          onError: (ErrorCodeType err, String msg) {
            debugPrint("[Agora] Error: $err — $msg");
          },
        ),
      );

      // 5. Setup Audio & Video
      await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await engine!.enableVideo();
      await engine!.enableAudio();
      await engine!.enableLocalVideo(true);
      await engine!.enableLocalAudio(true);
      await engine!.setDefaultAudioRouteToSpeakerphone(true);
      await engine!.adjustRecordingSignalVolume(100);
      await engine!.adjustPlaybackSignalVolume(100);

      await engine!.startPreview();
      isEngineReady.value = true;

      // 6. Join Channel
      await engine!.joinChannel(
        token: token,
        channelId: roomId.value.trim(),
        uid: 0,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
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
