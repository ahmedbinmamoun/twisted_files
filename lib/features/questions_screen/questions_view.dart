import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/features/common/animations/animated_question.dart';
import 'package:twisted_files/features/notes/notes_fab.dart';
import 'package:twisted_files/features/questions_screen/choose_suspect/choose_suspect.dart';
import 'package:twisted_files/features/questions_screen/question_content.dart';
import 'package:twisted_files/features/questions_screen/questions_cubit.dart';

class QuestionsView extends StatelessWidget {
  final CaseEntity caseEntity;
  final CaseRepository caseRepository;

  const QuestionsView({required this.caseEntity, required this.caseRepository});

  @override
  Widget build(BuildContext context) {
    final questions = caseEntity.questions;
    final suspects = caseEntity.suspects;

    return Stack(
      children: [
        Image.asset(AppAssests.backgroundImage, fit: BoxFit.fill),
        Scaffold(
          backgroundColor: AppColors.transparentColor,
          floatingActionButton: NotesFab(caseId: caseEntity.id),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: BlocBuilder<QuestionsCubit, int>(
                builder: (context, index) {
                  if (index >= questions.length) {
                    return ChooseSuspect(
                      caseRepository: caseRepository,
                      suspects: suspects,
                      caseEntity: caseEntity,
                    );
                  }

                  return AnimatedQuestion(
                    index: index,
                    child: QuestionContent(
                      questionIndex: index,
                      total: questions.length,
                      question: questions[index],
                      caseEntity: caseEntity,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}