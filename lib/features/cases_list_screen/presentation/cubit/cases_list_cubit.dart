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
 
  // ── Pagination config ─────────────────────────────────────────────────────
  static const int _pageSize = 6; // عدد القضايا في كل صفحة
 
  String          _difficulty = '';
  int             _currentPage = 0;
  bool            _isFetching  = false;
 
  CasesListCubit({
    required GetCasesByDifficultyUseCase getCases,
    required CanOpenCaseUseCase          canOpenCase,
    required ScoreRepository             scoreRepository,
  })  : _getCases        = getCases,
        _canOpenCase     = canOpenCase,
        _scoreRepository = scoreRepository,
        super(CasesListInitial());
 
  // ── First load ────────────────────────────────────────────────────────────
 
  Future<void> loadCases(String difficulty) async {
  _difficulty  = difficulty;
  _currentPage = 0;
  _isFetching  = false;

  emit(CasesListLoading());

  try {
    final results = await Future.wait([
      _getCases(difficulty, page: 0, pageSize: _pageSize),
      _scoreRepository.getAllCompletedCases(),
    ]);

    final cases      = results[0] as List<CaseEntity>;
    final completed  = results[1] as dynamic;
    final completedIds = <String>{
      for (final c in completed) c.caseId as String,
    };

    emit(CasesListLoaded(
      cases,
      completedCaseIds: completedIds,
      hasMore:          cases.length == _pageSize,
    ));
  } catch (e) {
    // ← افرق بين no internet وغيره
    final isNoInternet = e.toString().toLowerCase().contains('socket') ||
        e.toString().toLowerCase().contains('network') ||
        e.toString().toLowerCase().contains('connection') ||
        e.toString().toLowerCase().contains('host');

    emit(CasesListError(
      isNoInternet
          ? 'no_internet'
          : e.toString(),
    ));
  }
}
  // ── Load next page ────────────────────────────────────────────────────────
 
  Future<void> loadMore() async {
    final current = state;
    if (current is! CasesListLoaded) return;
    if (!current.hasMore)     return; // مفيش صفحات تانية
    if (_isFetching)          return; // بيجيب بالفعل
 
    _isFetching = true;
    emit(current.copyWith(isLoadingMore: true));
 
    try {
      _currentPage++;
      final newCases = await _getCases(
        _difficulty,
        page:     _currentPage,
        pageSize: _pageSize,
      );
 
      if (isClosed) return;
 
      final allCases = [...current.cases, ...newCases];
 
      emit(current.copyWith(
        cases:         allCases,
        isLoadingMore: false,
        hasMore:       newCases.length == _pageSize,
      ));
    } catch (e) {
      _currentPage--; // rollback عشان يعيد المحاولة
      if (!isClosed) {
        emit(current.copyWith(isLoadingMore: false));
      }
    } finally {
      _isFetching = false;
    }
  }
 
  // ── Unlock case temporarily ───────────────────────────────────────────────
 
  void unlockCaseTemporarily(String caseId) {
    final current = state;
    if (current is! CasesListLoaded) return;
    final updated = Set<String>.from(current.unlockedCaseIds)..add(caseId);
    emit(current.copyWith(unlockedCaseIds: updated));
  }
 
  bool canOpen(int totalScore, CaseEntity c) =>
      _canOpenCase(totalScore: totalScore, caseEntity: c);
}
 