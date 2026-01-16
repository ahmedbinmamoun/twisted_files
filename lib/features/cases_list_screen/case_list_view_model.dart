import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/domain/use_cases/can_open_case_use_case.dart';
import 'package:twisted_files/features/cases_list_screen/cubit/cases_list_state.dart';

class CasesListViewModel extends Cubit<CasesListState> {
  final CaseRepository repository;
  final String difficulty;

  CasesListViewModel({required this.repository, required this.difficulty})
      : super(CasesListInitial());

  Future<void> loadCases() async {
    emit(CasesListLoading());
    try {
      final cases = await repository.getCasesByDifficulty(difficulty);
      emit(CasesListLoaded(cases));
    } catch (e) {
      emit(CasesListError(e.toString()));
    }
  }

  bool canOpenCase(int totalScore, CaseEntity caseEntity) {
    return CanOpenCaseUseCase().call(
      totalScore: totalScore,
      caseEntity: caseEntity,
    );
  }
}