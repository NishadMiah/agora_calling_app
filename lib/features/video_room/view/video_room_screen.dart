import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
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
          // Remote Participant Fullscreen Video or Waiting View
          Positioned.fill(
            child: Obx(() {
              final remoteUid = controller.remoteUid.value;
              final engine = controller.engine;

              if (engine != null && remoteUid != null) {
                if (controller.isRemoteVideoMuted.value) {
                  return Container(
                    color: const Color(0xff111827),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 84.w,
                            height: 84.w,
                            decoration: const BoxDecoration(
                              color: Color(0xff1F2937),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.videocam_off_rounded,
                              size: 40.sp,
                              color: Colors.white54,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "User's camera is off",
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: engine,
                    canvas: VideoCanvas(uid: remoteUid),
                    connection: RtcConnection(
                      channelId: controller.roomId.value,
                    ),
                  ),
                );
              }

              // Waiting state when remote user hasn't joined yet
              return Container(
                color: const Color(0xff111827),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 84.w,
                        height: 84.w,
                        decoration: BoxDecoration(
                          color: const Color(0xff1F2937),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.callPrimary.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.person_search_rounded,
                          size: 40.sp,
                          color: AppColors.callPrimary,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        "Waiting for others to join...",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "Share Room ID: #${controller.roomId.value}",
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white60,
                        ),
                      ),
                    ],
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
                isEngineReady: controller.isEngineReady.value,
                onSwitchCamera: controller.switchCamera,
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
