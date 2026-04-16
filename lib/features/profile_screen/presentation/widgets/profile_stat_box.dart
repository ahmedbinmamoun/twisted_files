import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';

class ProfileStatBox extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  final bool isRank;

  const ProfileStatBox({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.isRank = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.scenderyColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(width: 2, color: AppColors.primaryColor),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppStyles.mediumBody.copyWith(color: AppColors.primaryColor)),
              SizedBox(height: 5.h),
              Center(child: Text(value, style: AppStyles.logo.copyWith(color: AppColors.primaryColor))),
              const Spacer(),
            ],
          ),
          if (isRank)
            Positioned(
              bottom: 0, right: 0,
              child: GestureDetector(
                onTap: onTap,
                child: Icon(Icons.arrow_forward_ios, size: 18.sp, color: AppColors.primaryColor),
              ),
            ),
        ],
      ),
    );
  }
}
