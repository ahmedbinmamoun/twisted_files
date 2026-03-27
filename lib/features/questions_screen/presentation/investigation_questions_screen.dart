import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/core/constants/app_assets.dart';
import 'package:twisted_files/core/di/injection_container.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/common/widgets/app_dialog.dart';
import 'package:twisted_files/features/questions_screen/presentation/cubit/questions_cubit.dart';
import 'package:twisted_files/features/questions_screen/presentation/questions_view.dart';
import 'package:twisted_files/features/score/presentation/score_view_model.dart';

class InvestigationQuestionsScreen extends StatelessWidget {
  final CaseEntity caseEntity;
  const InvestigationQuestionsScreen({super.key, required this.caseEntity});

  Future<bool> _onWillPop(BuildContext context) async {
    final scoreVm = getIt<ScoreViewModel>();
    bool shouldExit = false;

    await AppDialog.show(
      context,
      imagePath:          AppAssets.oldDetectiveIcon,
      title:              'Exit Investigation',
      summary:            'If you leave now, your progress and score for this case will be lost.\n\nDo you want to exit?',
      barrierDismissible: false,
      actions: [
        AppDialogAction(
          label:     'Cancel',
          onPressed: () {
            shouldExit = false;
            Navigator.of(context).pop();
          },
        ),
        AppDialogAction(
          label:     'Exit',
          isPrimary: true,
          onPressed: () async {
            await scoreVm.resetCase(caseEntity.id);
            shouldExit = true;
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    return shouldExit;
  }

  @override
  Widget build(BuildContext context) {
    getIt<ScoreViewModel>().startCaseSession(caseEntity.id);

    return BlocProvider(
      create: (_) => QuestionsCubit(totalQuestions: caseEntity.questions.length),
      child: Builder(
        builder: (ctx) => WillPopScope(
          onWillPop: () => _onWillPop(ctx),
          child: QuestionsView(caseEntity: caseEntity),
        ),
      ),
    );
  }
}
