import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';

class CallControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  const CallControlButton({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    this.iconColor = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 26.sp,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class FloatingLocalVideo extends StatelessWidget {
  final bool isCameraOff;

  const FloatingLocalVideo({
    super.key,
    this.isCameraOff = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96.w,
      height: 128.h,
      decoration: BoxDecoration(
        color: const Color(0xff1F2937),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.white,
          width: 2.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x59000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: isCameraOff
            ? Center(
                child: Icon(
                  Icons.videocam_off_rounded,
                  color: Colors.white54,
                  size: 28.sp,
                ),
              )
            : Image.asset(
                AppImages.localUser,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xff374151),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white70,
                      size: 32,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class VideoRoomHeader extends StatelessWidget {
  final String roomId;
  final int participantCount;
  final VoidCallback onBack;

  const VideoRoomHeader({
    super.key,
    required this.roomId,
    required this.participantCount,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20.sp,
              color: Colors.black,
            ),
            splashRadius: 20.r,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Video Room",
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "#$roomId",
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.subtitleGrey,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_outline_rounded,
                size: 20.sp,
                color: Colors.black,
              ),
              SizedBox(width: 4.w),
              Text(
                "$participantCount",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
