import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';
import 'package:twisted_files/domain/use_cases/update_score_use_case.dart';
import 'package:twisted_files/features/case_overview_screen.dart/case_overview_view.dart';
import 'package:twisted_files/features/investigation/cubit/investigation_cubit.dart';
import 'package:twisted_files/features/score/score_cubit/score_cubit.dart';

class CaseOverviewScreen extends StatelessWidget {
  final String caseId;
  final CaseRepository repository;
  final ScoreRepository scoreRepository;

  const CaseOverviewScreen({
    super.key,
    required this.caseId,
    required this.repository,
    required this.scoreRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => InvestigationCubit(repository)..loadCase(caseId),
        ),
        BlocProvider(
          create: (_) => ScoreCubit(
            activeCaseId: caseId, repository: scoreRepository, useCase: UpdateScoreUseCase(scoreRepository),
          ),
        ),
      ],
      child:  CaseOverviewView(),
    );
  }
}