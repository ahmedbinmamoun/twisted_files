import 'package:flutter/material.dart';
import 'package:twisted_files/config/di/config_di.dart';
import 'package:twisted_files/features/score/score_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(15),
        border: BoxBorder.all(color: AppColors.scenderyColor, width: 2),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: getIt<ScoreViewModel>(),
            builder: (context, _) {
              final total = getIt<ScoreViewModel>().score.totalScore;
              return Text(
                'Score: $total',
                style: AppStyles.mediumBody.copyWith(
                  color: AppColors.scenderyColor,
                ),
              );
            },
          ),
          SizedBox(width: 5.w),
          Image.asset(AppAssests.oneStarIcon, width: 12.w),
        ],
      ),
    );
  }
}
