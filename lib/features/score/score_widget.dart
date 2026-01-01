import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/features/score/score_cubit/score_cubit.dart';

class ScoreWidget extends StatelessWidget {
  const ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 5.h
      ),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(15),
        border: BoxBorder.all(color: AppColors.scenderyColor,width: 2),
      ),
      child: Row(
        children: [
          BlocBuilder<ScoreCubit, ScoreState>(
                          builder: (context, scoreState) {
                            return Text(
                              'Score: ${scoreState.score.totalScore}',
                              style: AppStyles.mediumBody.copyWith(
                                color: AppColors.scenderyColor
                              ),
                            );
                          },
                        ),
          SizedBox(width: 5.w,),
          Image.asset(AppAssests.oneStarIcon,width: 12.w,),
        ],
      ),
    );
  }
}