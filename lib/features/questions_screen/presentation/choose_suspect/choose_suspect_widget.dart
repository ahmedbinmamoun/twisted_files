import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/core/di/injection_container.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/suspect_entity.dart';
import 'package:twisted_files/features/questions_screen/presentation/choose_suspect/choose_suspect_cubit.dart';
import 'package:twisted_files/features/questions_screen/presentation/choose_suspect/choose_suspect_view.dart';
import 'package:twisted_files/features/rank_screen/domain/use_cases/get_user_rank_use_case.dart';
import 'package:twisted_files/features/score/presentation/score_view_model.dart';

/// Widget خارجي — يوفر الـ BlocProvider للـ ChooseSuspectCubit
class ChooseSuspectWidget extends StatelessWidget {
  final List<SuspectEntity> suspects;
  final CaseEntity          caseEntity;

  const ChooseSuspectWidget({
    super.key,
    required this.suspects,
    required this.caseEntity,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChooseSuspectCubit(
        scoreVm:    getIt<ScoreViewModel>(),
        caseEntity: caseEntity,
        getUserRank: getIt<GetUserRankUseCase>(),
      ),
      child: ChooseSuspectView(
        suspects:         suspects,
        correctSuspectId: caseEntity.correctSuspectId,
      ),
    );
  }
}
