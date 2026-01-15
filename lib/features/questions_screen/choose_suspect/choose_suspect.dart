import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/entities/case_result_entity.dart';
import 'package:twisted_files/domain/entities/suspect_entity.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/features/questions_screen/choose_suspect/choose_suspect_view.dart';
import 'package:twisted_files/features/result_dialog/case_result_dialog.dart';
import 'package:twisted_files/features/score/score_cubit/score_cubit.dart';

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
        final scoreCubit = innerContext.read<ScoreCubit>();

        return ChooseSuspectView(
          suspects: suspects,
          correctSuspectId: caseEntity.correctSuspectId,
          onSelect: (suspect) async {
            final isCorrect =
                suspect.id.trim() == (caseEntity.correctSuspectId ?? '').trim();
            print(
              'DEBUG: ChooseSuspect.onSelect start id=${suspect.id} isCorrect=$isCorrect',
            );

            try {
              print('DEBUG: calling solveSuspect');
              await scoreCubit.solveSuspect(caseEntity, isCorrect);
              print('DEBUG: after solveSuspect');

              print('DEBUG: calling finalizeCase');
              await scoreCubit.finalizeCase(caseEntity);
              print('DEBUG: after finalizeCase');

              final score = scoreCubit.state.score;
              print(
                'DEBUG: ready to show dialog, totalScore=${score.totalScore}',
              );

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
                      solvedQuestions: score.questionPoints ~/ 10,
                      totalQuestions: caseEntity.questions.length,
                      questionPoints: score.questionPoints,
                      suspectBonus: score.suspectPoints,
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
