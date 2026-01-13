import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';
import 'package:twisted_files/domain/use_cases/update_score_use_case.dart';
import 'package:twisted_files/features/questions_screen/questions_cubit.dart';
import 'package:twisted_files/features/questions_screen/questions_view.dart';
import 'package:twisted_files/features/score/score_cubit/score_cubit.dart';

class InvestigationQuestionsScreen extends StatelessWidget {
  final CaseEntity caseEntity;
  final UpdateScoreUseCase updateScoreUseCase;
  final ScoreRepository scoreRepository;
  final CaseRepository caseRepository;

  const InvestigationQuestionsScreen({
    super.key,
    required this.caseEntity,
    required this.updateScoreUseCase,
    required this.scoreRepository,
    required this.caseRepository,
  });

  Future<bool> _onWillPop(BuildContext context) async {
    final scoreCubit = context.read<ScoreCubit>();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('Exit Investigation'),
          content: const Text(
            'If you leave now, your progress and score for this case will be lost.\n\nDo you want to exit?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await scoreCubit.resetCase(caseEntity);
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

 
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => QuestionsCubit()),
        BlocProvider(
          create: (_) => ScoreCubit(
            activeCaseId: caseEntity.id,
            repository: scoreRepository,
            useCase: UpdateScoreUseCase(scoreRepository),
          ),
        ),
      ],
      child: Builder(
        builder: (innerContext) {
          return WillPopScope(
            onWillPop: () => _onWillPop(innerContext),
            child: QuestionsView(
              caseEntity: caseEntity,
              caseRepository: caseRepository,
            ),
          );
        }
      ),
    );
  }
}