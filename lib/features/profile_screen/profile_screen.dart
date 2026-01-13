import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/features/profile_screen/detective_card.dart';
import 'package:twisted_files/features/profile_screen/profile_stat_box.dart';
import 'package:twisted_files/features/score/score_cubit/score_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final randomRank = Random().nextInt(500) + 100; // مثال: 163

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 👤 اسم المستخدم
              RichText(
                text: TextSpan(
                  style: AppStyles.largeTitle,
                  children: [
                    const TextSpan(text: 'Detective '),
                    TextSpan(
                      text: 'Ahmed',
                      style: AppStyles.largeTitle.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              /// 📊 الصناديق
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<ScoreCubit, ScoreState>(
                      builder: (context, state) {
                        // if (state is ScoreState) {
                        return ProfileStatBox(
                          title: 'Total Score',
                          value: state.score.totalScore.toString(),
                          onTap: () {},
                        );
                        // }
                        // return  ProfileStatBox(
                        //   title: 'Total Score',
                        //   value: '--',
                        //   onTap: (){},
                        // );
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ProfileStatBox(
                      title: 'Rank',
                      value: '#163',
                      isRank: true,
                      onTap: () {},
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              /// 🕵️ بطاقة المحقق
              const DetectiveCard(),
            ],
          ),
        ),
      ),
    );
  }
}
