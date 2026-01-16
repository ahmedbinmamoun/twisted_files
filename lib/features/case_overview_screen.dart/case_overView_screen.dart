import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/features/case_overview_screen.dart/case_overview_view.dart';
import 'package:twisted_files/features/case_overview_screen.dart/cubit/case_overview_view_model.dart';
import 'package:twisted_files/config/di/config_di.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';

class CaseOverviewScreen extends StatelessWidget {
  final String caseId;

  const CaseOverviewScreen({super.key, required this.caseId});

  @override
  Widget build(BuildContext context) {
  final caseRepository = getIt<CaseRepository>();
  final scoreRepository = getIt<ScoreRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<CaseOverviewViewModel>(
          create: (_) => CaseOverviewViewModel(
            caseId: caseId,
            caseRepository: caseRepository,
            scoreRepository: scoreRepository,
          )..load(),
        ),
      ],
      child: const CaseOverviewView(),
    );
  }
}