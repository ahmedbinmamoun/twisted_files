import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assets.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/common/animations/animated_question.dart';
import 'package:twisted_files/features/notes/presentation/notes_fab.dart';
import 'package:twisted_files/features/questions_screen/presentation/choose_suspect/choose_suspect_widget.dart';
import 'package:twisted_files/features/questions_screen/presentation/cubit/questions_cubit.dart';
import 'package:twisted_files/features/questions_screen/presentation/cubit/questions_state.dart';
import 'package:twisted_files/features/questions_screen/presentation/question_content_widget.dart';

class QuestionsView extends StatelessWidget {
  final CaseEntity caseEntity;
  const QuestionsView({super.key, required this.caseEntity});

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
          floatingActionButton: NotesFab(caseId: caseEntity.id),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: BlocBuilder<QuestionsCubit, QuestionsState>(
                builder: (_, state) {
                  // ── انتهت الأسئلة — اختر المشتبه به ─────────────────────
                  if (state is QuestionsFinished) {
                    return ChooseSuspectWidget(
                      suspects:   caseEntity.suspects,
                      caseEntity: caseEntity,
                    );
                  }

                  // ── أسئلة ─────────────────────────────────────────────────
                  if (state is QuestionsAnswering) {
                    final index = state.index;
                    return AnimatedQuestion(
                      index: index,
                      child: QuestionContentWidget(
                        questionIndex: index,
                        total:         caseEntity.questions.length,
                        question:      caseEntity.questions[index],
                        caseEntity:    caseEntity,
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
