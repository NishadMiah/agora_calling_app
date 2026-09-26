import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../controller/video_room_controller.dart';
import '../widgets/video_room_widget.dart';

class VideoRoomScreen extends StatelessWidget {
  const VideoRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideoRoomController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Remote Participant Fullscreen Video
          Positioned.fill(
            child: Obx(() {
              if (controller.engine != null &&
                  controller.remoteUid.value != null) {
                return AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: controller.engine!,
                    canvas: VideoCanvas(uid: controller.remoteUid.value),
                    connection: RtcConnection(
                      channelId: controller.roomId.value,
                    ),
                  ),
                );
              }
              return Image.asset(
                AppImages.remoteUser,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xff111827),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white24,
                    ),
                  ),
                ),
              );
            }),
          ),

          // Bottom Gradient for Controls visibility
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 200.h,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xBF000000),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Top App Bar & Header
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Obx(
                () => VideoRoomHeader(
                  roomId: controller.roomId.value,
                  participantCount: controller.participantCount.value,
                  onBack: controller.leaveRoom,
                ),
              ),
            ),
          ),

          // Local Participant Picture-in-Picture (PIP) Window
          Positioned(
            top: 72.h,
            right: 16.w,
            child: Obx(
              () => FloatingLocalVideo(
                isCameraOff: controller.isCameraOff.value,
                engine: controller.engine,
                isJoined: controller.isJoined.value,
              ),
            ),
          ),

          // Bottom Call Controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 34.h,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CallControlButton(
                    icon: controller.isMicMuted.value
                        ? Icons.mic_off_rounded
                        : Icons.mic_rounded,
                    label: "Mic",
                    backgroundColor: controller.isMicMuted.value
                        ? const Color(0xCCEF4444)
                        : const Color(0xD92A2E35),
                    onTap: controller.toggleMic,
                  ),
                  SizedBox(width: 24.w),
                  CallControlButton(
                    icon: controller.isCameraOff.value
                        ? Icons.videocam_off_rounded
                        : Icons.videocam_rounded,
                    label: "Camera",
                    backgroundColor: controller.isCameraOff.value
                        ? const Color(0xCCEF4444)
                        : const Color(0xD92A2E35),
                    onTap: controller.toggleCamera,
                  ),
                  SizedBox(width: 24.w),
                  CallControlButton(
                    icon: Icons.call_end_rounded,
                    label: "Leave",
                    backgroundColor: AppColors.callRed,
                    onTap: controller.leaveRoom,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
