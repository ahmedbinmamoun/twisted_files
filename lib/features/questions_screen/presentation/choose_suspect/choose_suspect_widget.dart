import 'package:flutter/material.dart';
import 'package:twisted_files/core/di/injection_container.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_result_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/suspect_entity.dart';
import 'package:twisted_files/features/questions_screen/presentation/choose_suspect/choose_suspect_view.dart';
import 'package:twisted_files/features/result_dialog/presentation/case_result_dialog.dart';
import 'package:twisted_files/features/score/presentation/score_view_model.dart';

class ChooseSuspectWidget extends StatelessWidget {
  final List<SuspectEntity> suspects;
  final CaseEntity caseEntity;

  const ChooseSuspectWidget({
    super.key,
    required this.suspects,
    required this.caseEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) {
        final scoreVm = getIt<ScoreViewModel>();
        return ChooseSuspectView(
          suspects: suspects,
          correctSuspectId: caseEntity.correctSuspectId,
          onSelect: (suspect) async {
            final isCorrect = suspect.id.trim() == caseEntity.correctSuspectId.trim();
            try {
              await scoreVm.solveSuspect(caseEntity);
              final sessionSolved        = scoreVm.sessionSolvedCount;
              final sessionQuestionPts   = scoreVm.sessionQuestionGross;
              final sessionPenalty       = scoreVm.sessionPenalty;
              final sessionSuspect       = scoreVm.sessionSuspectGross;
              await scoreVm.finalizeCase(caseEntity);
              final score = scoreVm.score;
              await showDialog(
                context: ctx,
                barrierDismissible: false,
                builder: (_) => CaseResultDialog(
                  result: CaseResultEntity(
                    caseNumber: caseEntity.caseNumber,
                    caseTitle: caseEntity.title,
                    isSuccess: isCorrect,
                    solvedQuestions: sessionSolved,
                    totalQuestions: caseEntity.questions.length,
                    questionPoints: sessionQuestionPts,
                    suspectBonus: sessionSuspect,
                    penalty: sessionPenalty,
                    totalScore: score.totalScore,
                    rank: 869,
                  ),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          },
        );
      },
    );
  }
}
