import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/navigation/app_routes.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/questions_screen/choose_suspect_view.dart';
import 'package:twisted_files/features/questions_screen/questions_cubit.dart';

class InvestigationQuestionsScreen extends StatelessWidget {
  const InvestigationQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final caseEntity =
        ModalRoute.of(context)!.settings.arguments as CaseEntity;

    final questions = caseEntity.questions;
    final suspects = caseEntity.suspects;

    return BlocProvider(
      create: (_) => QuestionsCubit(),
      child: Stack(
        
        children: [
          Image.asset(
          AppAssests.backgroundImage,
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
          Scaffold(
            backgroundColor: AppColors.transparentColor,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: BlocBuilder<QuestionsCubit, int>(
                  builder: (context, index) {
                    if (index >= questions.length) {
                      return ChooseSuspectView(
                        suspects: suspects,
                        onSelect: (suspect) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.homeScreen,
                            (route) => false,
                            arguments: {
                              'case': caseEntity,
                              'suspect': suspect,
                            },
                          );
                        },
                      );
                    }
          
                    final question = questions[index];
          
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${index + 1}/${questions.length}',
                          style: AppStyles.mediumBody,
                        ),
          
                        SizedBox(height: 140.h),
          
                        Text(
                          question.question,
                          style: AppStyles.largeTitle,
                        ),
          
                        SizedBox(height: 50.h),
          
                        ...question.options.map(
                          (option) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: PrimaryButton(
                              text: option,
                              onPressed: () {
                                context
                                    .read<QuestionsCubit>()
                                    .next();
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}