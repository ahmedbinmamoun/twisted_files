import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';

class DetectiveCard extends StatelessWidget {
  const DetectiveCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.scenderyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detective ID', style: AppStyles.mediumBody),
          Text(
            'TJ637C4F',
            style: AppStyles.mediumTitle.copyWith(
              color: AppColors.primaryColor,
            ),
          ),

          SizedBox(height: 12.h),

          _row('Department', 'Special Crimes'),
          _row('Clearance Level', 'Level 3'),
          _row('Cases Solved', '27'),
          _row('Status', 'Active'),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppStyles.mediumBody),
          Text(
            value,
            style: AppStyles.mediumBody.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}