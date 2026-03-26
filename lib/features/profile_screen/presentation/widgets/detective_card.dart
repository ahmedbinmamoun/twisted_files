import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/features/profile_screen/domain/entities/profile_stats_entity.dart';

class DetectiveCard extends StatelessWidget {
  final ProfileStatsEntity stats;
  const DetectiveCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final total = stats.easySolved + stats.mediumSolved + stats.hardSolved;
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
          Text('TJ637C4F', style: AppStyles.mediumTitle.copyWith(color: AppColors.primaryColor)),
          SizedBox(height: 12.h),
          _row('Department', 'Special Crimes'),
          _row('Cases Solved', total.toString()),
          _row('Easy Cases Solved', stats.easySolved.toString()),
          _row('Medium Cases Solved', stats.mediumSolved.toString()),
          _row('Hard Cases Solved', stats.hardSolved.toString()),
          _row('Status', 'Active'),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppStyles.mediumBody),
        Text(value, style: AppStyles.mediumBody.copyWith(color: AppColors.primaryColor)),
      ],
    ),
  );
}
