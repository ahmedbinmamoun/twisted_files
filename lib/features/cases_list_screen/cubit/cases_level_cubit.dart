import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/features/cases_list_screen/cubit/cases_list_state.dart';

class CasesListCubit extends Cubit<CasesListState> {
  final CaseRepository repository;

  CasesListCubit(this.repository) : super(CasesListInitial());

  Future<void> loadCasesByDifficulty(String difficulty) async {
    emit(CasesListLoading());
    try {
      final cases = await repository.getCasesByDifficulty(difficulty);
      emit(CasesListLoaded(cases));
    } catch (e) {
      emit(CasesListError(e.toString()));
    }
  }
}