import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/core/navigation/app_navigator.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/entities/suspect_entity.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/features/cases_list_screen/cases_list_screen.dart';
import 'package:twisted_files/features/home_screen/home_screen.dart';
import 'package:twisted_files/features/questions_screen/choose_suspect_view.dart';
import 'package:twisted_files/features/score/score_cubit/score_cubit.dart';

class ChooseSuspect extends StatelessWidget {
  final List<SuspectEntity> suspects;
  final CaseEntity caseEntity;
  final CaseRepository caseRepository;


  const ChooseSuspect({
    required this.suspects,
    required this.caseEntity,
    required this.caseRepository
  });

  @override
  Widget build(BuildContext context) {
    final scoreCubit = context.read<ScoreCubit>();

    return ChooseSuspectView(
      suspects: suspects,
      onSelect: (suspect) async {
        await scoreCubit.solveSuspect(caseEntity);
        await scoreCubit.finalizeCase(caseEntity);

        AppNavigator.push(context, 
        // CasesListScreen(repository: caseRepository)
        HomeScreen(repository: caseRepository)
        );
        
      },
    );
  }
}