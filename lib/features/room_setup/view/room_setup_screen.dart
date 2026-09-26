import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../controller/room_setup_controller.dart';
import '../widgets/room_setup_widget.dart';

class RoomSetupScreen extends StatelessWidget {
  const RoomSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RoomSetupController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.sp,
            color: AppColors.darkHeading,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Obx(
            () => controller.isCreateMode.value
                ? _buildCreateRoomSection(controller)
                : _buildJoinRoomSection(controller),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateRoomSection(RoomSetupController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Text(
          "Create Room",
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.darkHeading,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          "Create a new video room and share\nthe room ID with others",
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.subtitleGrey,
            height: 1.35,
          ),
        ),
        SizedBox(height: 18.h),
        RoomIdCard(
          roomId: controller.generatedRoomId.value,
          onCopy: controller.copyRoomId,
        ),
        SizedBox(height: 10.h),
        Text(
          "Share this Room ID with others to join",
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.placeholderGrey,
          ),
        ),
        SizedBox(height: 16.h),
        RoomActionButton(
          title: "Start Room",
          icon: Icons.videocam_rounded,
          onTap: controller.startRoom,
        ),
        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _buildJoinRoomSection(RoomSetupController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Text(
          "Join Room",
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.darkHeading,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          "Enter the room ID to join an existing\nvideo room",
          style: GoogleFonts.poppins(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.subtitleGrey,
            height: 1.35,
          ),
        ),
        SizedBox(height: 18.h),
        TextField(
          controller: controller.joinRoomIdController,
          keyboardType: TextInputType.number,
          style: GoogleFonts.poppins(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.darkHeading,
          ),
          decoration: InputDecoration(
            hintText: "Enter Room ID",
            hintStyle: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.placeholderGrey,
            ),
            prefixIcon: Icon(
              Icons.tag_rounded,
              size: 24.sp,
              color: AppColors.placeholderGrey,
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(
                color: AppColors.borderLight,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(
                color: AppColors.callPrimary,
                width: 1.5,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        RoomActionButton(
          title: "Join Room",
          icon: Icons.link_rounded,
          onTap: controller.joinRoom,
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
}
