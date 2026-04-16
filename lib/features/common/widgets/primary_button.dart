import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final Widget? widget;
  final bool useWidget;

  const PrimaryButton({
    super.key,
    this.text,
    required this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.useWidget = false,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor ?? AppColors.primaryColor,
            width: 3.w,
          ),
        ),
        child: Center(
          child: useWidget
              ? widget
              : Text(
                  text!,
                  maxLines: null,
                  softWrap: true,
                  style: AppStyles.mediumButtonText.copyWith(
                    color: borderColor ?? AppColors.scenderyColor,
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }
}
