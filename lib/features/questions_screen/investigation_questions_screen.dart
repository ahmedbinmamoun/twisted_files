import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';
import 'package:twisted_files/domain/use_cases/update_score_use_case.dart';
import 'package:twisted_files/config/di/config_di.dart';
import 'package:twisted_files/features/score/score_viewmodel.dart';
import 'package:twisted_files/features/questions_screen/questions_cubit.dart';
import 'package:twisted_files/features/questions_screen/questions_view.dart';
// migrated to ScoreViewModel via DI

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
  final scoreVm = getIt<ScoreViewModel>();

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
                await scoreVm.resetCase(caseEntity.id);
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
  // Ensure a case session is started whenever this screen appears.
  // Fire-and-forget call; startCaseSession is idempotent for the same case.
  getIt<ScoreViewModel>().startCaseSession(caseEntity.id);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => QuestionsCubit()),
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