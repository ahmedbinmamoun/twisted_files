import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/navigation/app_navigator.dart';
import 'package:twisted_files/core/navigation/app_routes.dart';
import 'package:twisted_files/domain/entities/case_result_entity.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/result_dialog/widgets/result_row.dart';

class CaseResultDialog extends StatelessWidget {
  final CaseResultEntity result;

  const CaseResultDialog({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final Color resultColor = result.isSuccess
        ? AppColors.greenColor
        : AppColors.redColor;

    return Dialog(
      backgroundColor: AppColors.transparentColor,
      insetPadding: EdgeInsets.all(20.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.offWhiteColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Case ${result.caseNumber} | ',
                  style: AppStyles.mediumBody,
                ),
                SizedBox(width: 4.w),
                Text(result.caseTitle, style: AppStyles.mediumBody),
              ],
            ),

            SizedBox(height: 20.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              decoration: BoxDecoration(
                color: resultColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: resultColor),
              ),
              child: Center(
                child: Text(
                  result.isSuccess ? 'SUCCESS' : 'FAILED',
                  style: AppStyles.largeTitle.copyWith(
                    color: resultColor.withOpacity(0.6),
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            ResultRow(
              label: 'Questions Solved',
              value: '${result.solvedQuestions}/${result.totalQuestions}',
            ),
            ResultRow(
              label: 'Question Points',
              value: '${result.questionPoints}',
            ),
            ResultRow(label: 'Suspect Bonus', value: '${result.suspectBonus}'),
            ResultRow(
              label: 'Total Score',
              value: '${result.totalScore}',
              bold: true,
            ),
            ResultRow(label: 'Your Rank', value: '#${result.rank}'),

            SizedBox(height: 20.h),

            Center(
              child: Text(
                result.isSuccess
                    ? 'The truth always leaves a trace.'
                    : 'Not every case is Solved on first try',
                style: AppStyles.mediumBody.copyWith(
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 24.h),

            PrimaryButton(
              text: 'Done',
              onPressed: () {
                Navigator.pop(context);
                Navigator.popUntil(context, (route){
                  return route.settings.name == AppRoutes.caesesListScreen;
                });
                // (
                //   context,
                //   AppRoutes.caesesListScreen,
                //   (route) => false,
                //   arguments: result.returnRoute,
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
