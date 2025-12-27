import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';

abstract class CasesListState {}

class CasesListInitial extends CasesListState {}
class CasesListLoading extends CasesListState {}
class CasesListLoaded extends CasesListState {
  final List<CaseEntity> cases;
  CasesListLoaded(this.cases);
}
class CasesListError extends CasesListState {
  final String message;
  CasesListError(this.message);
}

class CasesListCubit extends Cubit<CasesListState> {
  final CaseRepository repository;
  CasesListCubit(this.repository) : super(CasesListInitial());

  Future<void> loadCases() async {
    emit(CasesListLoading());
    try {
      final cases = await repository.getAllCases();
      emit(CasesListLoaded(cases));
    } catch (e) {
      emit(CasesListError(e.toString()));
    }
  }
}