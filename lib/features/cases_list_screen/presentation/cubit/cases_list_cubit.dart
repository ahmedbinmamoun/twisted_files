import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/use_cases/can_open_case_use_case.dart';
import 'package:twisted_files/features/cases_list_screen/domain/use_cases/get_cases_by_difficulty_use_case.dart';
import 'package:twisted_files/features/score/domain/repositories/score_repository.dart';
import 'cases_list_state.dart';

class CasesListCubit extends Cubit<CasesListState> {
  final GetCasesByDifficultyUseCase _getCases;
  final CanOpenCaseUseCase          _canOpenCase;
  final ScoreRepository             _scoreRepository; 

  CasesListCubit({
    required GetCasesByDifficultyUseCase getCases,
    required CanOpenCaseUseCase          canOpenCase,
    required ScoreRepository             scoreRepository, 
  })  : _getCases        = getCases,
        _canOpenCase     = canOpenCase,
        _scoreRepository = scoreRepository,
        super(CasesListInitial());

  Future<void> loadCases(String difficulty) async {
    emit(CasesListLoading());
    try {
      final results = await Future.wait([
        _getCases(difficulty),
        _scoreRepository.getAllCompletedCases(),
      ]);

      final cases     = results[0] as List<CaseEntity>;
      final completed = results[1] as dynamic;

      final completedIds = <String>{
        for (final c in completed) c.caseId as String,
      };

      emit(CasesListLoaded(cases, completedCaseIds: completedIds));
    } catch (e) {
      emit(CasesListError(e.toString()));
    }
  }

  bool canOpen(int totalScore, CaseEntity c) =>
      _canOpenCase(totalScore: totalScore, caseEntity: c);
}