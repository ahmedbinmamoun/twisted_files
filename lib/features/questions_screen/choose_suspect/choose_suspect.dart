import 'package:flutter/material.dart';
import 'package:twisted_files/config/di/config_di.dart';
import 'package:twisted_files/features/score/score_viewmodel.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/entities/case_result_entity.dart';
import 'package:twisted_files/domain/entities/suspect_entity.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/features/questions_screen/choose_suspect/choose_suspect_view.dart';
import 'package:twisted_files/features/result_dialog/case_result_dialog.dart';
// removed ScoreCubit usage; now using ScoreViewModel via DI

class ChooseSuspect extends StatelessWidget {
  final List<SuspectEntity> suspects;
  final CaseEntity caseEntity;
  final CaseRepository caseRepository;

  const ChooseSuspect({
    super.key,
    required this.suspects,
    required this.caseEntity,
    required this.caseRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (innerContext) {
        final scoreVm = getIt<ScoreViewModel>();

        return ChooseSuspectView(
          suspects: suspects,
          correctSuspectId: caseEntity.correctSuspectId,
          onSelect: (suspect) async {
            final correctId = caseEntity.correctSuspectId;
            final isCorrect = suspect.id.trim() == correctId.trim();
            print(
              'DEBUG: ChooseSuspect.onSelect start id=${suspect.id} isCorrect=$isCorrect',
            );

            try {
              print('DEBUG: calling solveSuspect');
              await scoreVm.solveSuspect(caseEntity);
              print('DEBUG: after solveSuspect');

              // capture session stats before finalize (finalizeCase clears them)
              final sessionSolved = scoreVm.sessionSolvedCount;
              final sessionQuestionPoints = scoreVm.sessionQuestionGross;
              final sessionPenalty = scoreVm.sessionPenalty;
              final sessionSuspect = scoreVm.sessionSuspectGross;

              print('DEBUG: calling finalizeCase');
              await scoreVm.finalizeCase(caseEntity);
              print('DEBUG: after finalizeCase');

              final score = scoreVm.score; // final saved score
              print('DEBUG: ready to show dialog, totalScore=${score.totalScore}');

              await showDialog(
                context: innerContext,
                barrierDismissible: false,
                builder: (dialogContext) {
                  print('DEBUG: in dialog builder');
                  return CaseResultDialog(
                    result: CaseResultEntity(
                      caseNumber: caseEntity.caseNumber,
                      caseTitle: caseEntity.title,
                      isSuccess: isCorrect,
                      solvedQuestions: sessionSolved,
                      totalQuestions: caseEntity.questions.length,
                      questionPoints: sessionQuestionPoints,
                      suspectBonus: sessionSuspect,
                      penalty: sessionPenalty,
                      totalScore: score.totalScore,
                      rank: 869,
                    ),
                  );
                },
              );

              print('DEBUG: after showDialog');
            } catch (e, st) {
              print('ERROR ChooseSuspect.onSelect: $e\n$st');
              ScaffoldMessenger.of(
                innerContext,
              ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
            }
          },
        );
      },
    );
  }
}