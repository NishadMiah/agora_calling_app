import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_colors.dart';
import 'custom_text.dart';
import 'custom_text_field.dart';

class CustomFormCard extends StatelessWidget {
  final String title;
  final String? hintText;
  final TextEditingController controller;
  final bool isPassword;
  final bool? hasSuffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool hasBackgroundColor;
  final bool isMultiLine;
  final String? Function(dynamic)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLine;
  final double? fontSize;
  final Color? titleColor;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool isStar;

  const CustomFormCard({
    super.key,
    required this.title,
    required this.controller,
    this.isPassword = false,
    this.hasSuffixIcon,
    this.readOnly = false,
    this.onTap,
    this.hasBackgroundColor = false,
    this.isMultiLine = false,
    this.validator,
    this.hintText,
    this.isStar = true,
    this.suffixIcon,
    this.maxLine,
    this.fontSize,
    this.titleColor,
    this.prefixIcon,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(
              text: title,
              color: titleColor ?? AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: fontSize ?? 18.w,
              bottom: 12.h,
              textAlign: TextAlign.start,
              maxLines: 2,
            ),
            if (isStar)
              CustomText(
                text: '*',
                color: AppColors.red,
                fontWeight: FontWeight.w600,
                fontSize: 18.w,
                bottom: 12.h,
                textAlign: TextAlign.start,
                maxLines: 2,
              ),
          ],
        ),
        CustomTextField(
          isDens: true,
          onChanged: onChanged,
          prefixIcon: prefixIcon,
          validator: validator,
          readOnly: readOnly,
          hintText: hintText,
          cursorColor: AppColors.black,
          hintStyle: GoogleFonts.roboto(
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: AppColors.black_06,
          ),
          suffixIcon: suffixIcon,
          isPassword: isPassword,
          textEditingController: controller,
          inputTextStyle: GoogleFonts.poppins(
            color: AppColors.black,
            fontSize: 18.sp,
          ),
          fillColor: hasBackgroundColor
              ? Colors.transparent
              : Colors.transparent,
          fieldBorderColor: AppColors.primary.withValues(alpha: .5),
          keyboardType:
              keyboardType ??
              (isPassword ? TextInputType.visiblePassword : TextInputType.text),
          onTap: onTap,
          maxLines: isPassword ? 1 : maxLine,
          fieldBorderRadius: 12.r,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
