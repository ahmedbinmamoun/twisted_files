import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assets.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/di/injection_container.dart';
import 'package:twisted_files/features/score/presentation/score_view_model.dart';

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.scenderyColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: getIt<ScoreViewModel>(),
            builder: (_, __) => Text(
              'Score: ${getIt<ScoreViewModel>().score.totalScore}',
              style: AppStyles.mediumBody.copyWith(color: AppColors.scenderyColor),
            ),
          ),
          SizedBox(width: 5.w),
          Image.asset(AppAssets.oneStarIcon, width: 12.w),
        ],
      ),
    );
  }
}
