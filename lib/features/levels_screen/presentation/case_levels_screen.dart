import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assets.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/navigation/app_routes.dart';
import 'package:twisted_files/features/common/widgets/primary_card.dart';

class CaseLevelsScreen extends StatelessWidget {
  const CaseLevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RepaintBoundary(
          child: LayoutBuilder(
            builder: (context, constraints) => Image.asset(
              AppAssets.backgroundImage,
              fit: BoxFit.fill,
              cacheWidth: constraints.maxWidth.toInt(),
              cacheHeight: constraints.maxHeight.toInt(),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: AppColors.transparentColor,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                SizedBox(height: 120.h),
                Text('CASE LEVEL', style: AppStyles.logo),
                SizedBox(height: 120.h),
                PrimaryCard(
                  icon: AppAssets.oneStarIcon,
                  text: 'EASY CASES',
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.casesListScreen,
                    arguments: 'easy',
                  ),
                ),
                SizedBox(height: 20.h),
                PrimaryCard(
                  icon: AppAssets.twoStarsIcon,
                  text: 'MEDIUM CASES',
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.casesListScreen,
                    arguments: 'medium',
                  ),
                ),
                SizedBox(height: 20.h),
                PrimaryCard(
                  icon: AppAssets.threeStarsIcon,
                  text: 'HARD CASES',
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.casesListScreen,
                    arguments: 'hard',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
