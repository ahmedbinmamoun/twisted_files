import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/use_cases/can_open_case_use_case.dart';
import 'package:twisted_files/features/cases_list_screen/domain/use_cases/get_cases_by_difficulty_use_case.dart';
import 'cases_list_state.dart';

/// SRP: Only responsible for loading cases list and exposing UI state.
class CasesListCubit extends Cubit<CasesListState> {
  final GetCasesByDifficultyUseCase _getCases;
  final CanOpenCaseUseCase _canOpenCase;

  CasesListCubit({
    required GetCasesByDifficultyUseCase getCases,
    required CanOpenCaseUseCase canOpenCase,
  })  : _getCases = getCases,
        _canOpenCase = canOpenCase,
        super(CasesListInitial());

  Future<void> loadCases(String difficulty) async {
    emit(CasesListLoading());
    try {
      final cases = await _getCases(difficulty);
      emit(CasesListLoaded(cases));
    } catch (e) {
      emit(CasesListError(e.toString()));
    }
  }

  bool canOpen(int totalScore, CaseEntity caseEntity) =>
      _canOpenCase(totalScore: totalScore, caseEntity: caseEntity);
}
