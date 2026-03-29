import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assets.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/navigation/app_navigator.dart';
import 'package:twisted_files/features/common/widgets/primary_card.dart';
import 'package:twisted_files/features/levels_screen/presentation/case_levels_screen.dart';
import 'package:twisted_files/features/profile_screen/presentation/profile_screen.dart';
import 'package:twisted_files/features/rank_screen/presentation/rank_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(AppAssets.backgroundImage, fit: BoxFit.fill),
        Scaffold(
          backgroundColor: AppColors.transparentColor,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                SizedBox(height: 120.h),
                Text('Twisted Files', style: AppStyles.logo),
                SizedBox(height: 120.h),
                PrimaryCard(
                  icon: AppAssets.folderIcon,
                  text: 'CASES FILES',
                  onPressed: () => AppNavigator.push(context, const CaseLevelsScreen()),
                ),
                SizedBox(height: 20.h),
                PrimaryCard(
                  icon: AppAssets.rankIcon,
                  text: 'LEADERBOARD',
                  onPressed: () => AppNavigator.push(context, const RankScreen()),
                ),
                SizedBox(height: 20.h),
                PrimaryCard(
                  icon: AppAssets.oldDetectiveIcon,
                  text: 'PROFILE',
                  onPressed: () => AppNavigator.push(context, const ProfileScreen()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
