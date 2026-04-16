import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assets.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';

/// زر Google Sign-In — pure UI، لا لوجيك
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool          isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:  double.infinity,
      height: 52.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side:  BorderSide(color: AppColors.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w, height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.googleIcon, width: 20.w),
                  SizedBox(width: 10.w),
                  Text(
                    'Sign in with Google',
                    style: AppStyles.mediumBody.copyWith(
                      color:      AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
