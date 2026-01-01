import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/navigation/app_routes.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';
import 'package:twisted_files/domain/use_cases/update_score_use_case.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/questions_screen/choose_suspect_view.dart';
import 'package:twisted_files/features/questions_screen/questions_cubit.dart';
import 'package:twisted_files/features/score/score_cubit/score_cubit.dart';
import 'package:twisted_files/features/score/score_widget.dart';

class InvestigationQuestionsScreen extends StatelessWidget {
  final CaseEntity caseEntity;
  final UpdateScoreUseCase updateScoreUseCase;
  final ScoreRepository scoreRepository;

  const InvestigationQuestionsScreen({
    super.key,
    required this.caseEntity,
    required this.updateScoreUseCase,
    required this.scoreRepository
  });

  @override
  Widget build(BuildContext context) {
    final questions = caseEntity.questions;
    final suspects = caseEntity.suspects;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => QuestionsCubit()),
        BlocProvider(create: (_) => ScoreCubit(updateScoreUseCase, scoreRepository)),
      ],
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
                    final scoreCubit = context.read<ScoreCubit>();
                    final currentScore = scoreCubit.state.score;

                    if (index >= questions.length) {
                      return ChooseSuspectView(
                        suspects: suspects,
                        onSelect: (suspect) async {
                          await scoreCubit.solveSuspect(caseEntity);
                          print('suspect points added, total: ${scoreCubit.state.score.totalScore}');

                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.homeScreen,
                            (route) => false,
                            arguments: {
                              'case': caseEntity,
                              'suspect': suspect,
                              'score': scoreCubit.state.score,
                            },
                          );
                        },
                      );
                    }

                    final question = questions[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        SizedBox(height: 10.h,),
                        Row(
                          children: [
                            Text(
                              'Question ${index + 1}/${questions.length}',
                              style: AppStyles.mediumBody,
                            ),
                            Spacer(),
                            ScoreWidget(),
                          ],
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
                              onPressed: () async {
                                final isCorrect = option == question.correctAnswer;
                                if (isCorrect) {
                                print('correct answer, total score: ${scoreCubit.state.score.totalScore}');
                                  await scoreCubit.solveQuestion(caseEntity);
                                  context.read<QuestionsCubit>().next();
                                  print('correct answer, total score: ${scoreCubit.state.score.totalScore}');
                                } else {
                                  print('wrong answer, total score: ${scoreCubit.state.score.totalScore}');
                                  context.read<QuestionsCubit>().next();
                                }
                                
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        BlocBuilder<ScoreCubit, ScoreState>(
                          builder: (context, scoreState) {
                            return Text(
                              'Score: ${scoreState.score.totalScore}',
                              style: AppStyles.mediumBody,
                            );
                          },
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