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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => QuestionsCubit()),
        BlocProvider(
          create: (_) => ScoreCubit(
            updateScoreUseCase,
            scoreRepository,
            activeCaseId: caseEntity.id,
          ),
        ),
      ],
      child: QuestionsView(caseEntity: caseEntity, caseRepository: caseRepository,),
    );
  }
}