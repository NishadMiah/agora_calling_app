import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../controller/home_controller.dart';
import '../widgets/home_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 36.h),
              Text(
                "Video Room",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkHeading,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Create or join a video room\nand start calling",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subtitleGrey,
                  height: 1.4,
                ),
              ),
              const Spacer(),
              Container(
                width: 130.w,
                height: 130.w,
                decoration: const BoxDecoration(
                  color: AppColors.iconCircleBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.videocam_rounded,
                    size: 56.sp,
                    color: AppColors.callPrimary,
                  ),
                ),
              ),
              const Spacer(),
              HomeActionCard(
                title: "Create Room",
                subtitle: "Create a new room and start\na video call",
                icon: Icons.add_rounded,
                iconBgColor: AppColors.callPrimary,
                onTap: controller.navigateToCreateRoom,
              ),
              SizedBox(height: 16.h),
              HomeActionCard(
                title: "Join Room",
                subtitle: "Join an existing room using\nroom ID",
                icon: Icons.link_rounded,
                iconBgColor: AppColors.callPurple,
                onTap: controller.navigateToJoinRoom,
              ),
              SizedBox(height: 28.h),
            ],
          ),
        ),
      ),
    );
  }
}