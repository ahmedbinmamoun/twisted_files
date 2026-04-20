import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
 
abstract class CasesListState {}
 
class CasesListInitial extends CasesListState {}
class CasesListLoading  extends CasesListState {}
 
class CasesListLoaded extends CasesListState {
  final List<CaseEntity> cases;
  final Set<String>      completedCaseIds;
  final Set<String>      unlockedCaseIds;
  final bool             isLoadingMore; 
  final bool             hasMore;       
 
  CasesListLoaded(
    this.cases, {
    this.completedCaseIds = const {},
    this.unlockedCaseIds  = const {},
    this.isLoadingMore    = false,
    this.hasMore          = true,
  });
 
  CasesListLoaded copyWith({
    List<CaseEntity>? cases,
    Set<String>?      completedCaseIds,
    Set<String>?      unlockedCaseIds,
    bool?             isLoadingMore,
    bool?             hasMore,
  }) => CasesListLoaded(
    cases             ?? this.cases,
    completedCaseIds: completedCaseIds ?? this.completedCaseIds,
    unlockedCaseIds:  unlockedCaseIds  ?? this.unlockedCaseIds,
    isLoadingMore:    isLoadingMore    ?? this.isLoadingMore,
    hasMore:          hasMore          ?? this.hasMore,
  );
}
 
class CasesListError extends CasesListState {
  final String message;
  CasesListError(this.message);
}
 