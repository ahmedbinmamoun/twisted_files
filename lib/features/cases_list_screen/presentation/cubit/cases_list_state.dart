import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';

abstract class CasesListState {}

class CasesListInitial extends CasesListState {}
class CasesListLoading extends CasesListState {}
class CasesListLoaded  extends CasesListState {
  final List<CaseEntity> cases;
  CasesListLoaded(this.cases);
}
class CasesListError extends CasesListState {
  final String message;
  CasesListError(this.message);
}
