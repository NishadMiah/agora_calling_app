// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';

class Navbar extends StatefulWidget {
  final int currentIndex;
  const Navbar({super.key, required this.currentIndex});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late int bottomNavIndex;

  final List<String> selectedIcon = [
    AppIcons.home,
    AppIcons.programe,
    AppIcons.gallery,
    AppIcons.access,
    AppIcons.profile,
  ];
  final List<String> name = [
    'Home',
    'Programe',
    'Gallery',
    'Access',
    'Profile',
  ];

  @override
  void initState() {
    bottomNavIndex = widget.currentIndex;
    super.initState();
  }

  void _handleTap(int index) {
    if (bottomNavIndex == index) return;

    setState(() {
      bottomNavIndex = index;
    });

    switch (index) {
      case 0:
        // Get.offAllNamed(AppRoutes.homeScreen);
        break;
      case 1:
        // Get.offAllNamed(AppRoutes.programeScreen);
        break;
      case 2:
        // Get.offAllNamed(AppRoutes.galleryScreen);
        break;
      case 3:
        // Get.offAllNamed(AppRoutes.accessScreen);
        break;
      case 4:
        // Get.offAllNamed(AppRoutes.profileScreen);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: bottomNavIndex,
      onTap: _handleTap,
      backgroundColor: AppColors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.iconColor,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: List.generate(selectedIcon.length, (i) {
        return BottomNavigationBarItem(
          icon: CustomNavIcon(
            assetName: selectedIcon[i],
            isSelected: i == bottomNavIndex,
          ),
          label: name[i],
        );
      }),
    );
  }
}

class CustomNavIcon extends StatelessWidget {
  final String assetName;
  final bool isSelected;

  const CustomNavIcon({
    super.key,
    required this.assetName,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      colorFilter: ColorFilter.mode(
        isSelected ? AppColors.primary : AppColors.iconColor,
        BlendMode.srcIn,
      ),
      color: isSelected ? AppColors.primary : AppColors.iconColor,
    );
  }
}
