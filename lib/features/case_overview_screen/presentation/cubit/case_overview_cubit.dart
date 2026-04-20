import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/features/case_overview_screen/domain/use_cases/get_case_use_case.dart';
import 'package:twisted_files/features/case_overview_screen/domain/use_cases/reset_case_use_case.dart';
import 'package:twisted_files/features/score/domain/repositories/score_repository.dart';
import 'package:twisted_files/features/score/presentation/score_view_model.dart';
import 'case_overview_state.dart';

class CaseOverviewCubit extends Cubit<CaseOverviewState> {
  final GetCaseUseCase   _getCase;
  final ResetCaseUseCase _resetCase;
  final ScoreRepository  _scoreRepository;
  final ScoreViewModel   _scoreViewModel;
  final String           caseId;

  CaseOverviewCubit({
    required GetCaseUseCase   getCase,
    required ResetCaseUseCase resetCase,
    required ScoreRepository  scoreRepository,
    required ScoreViewModel   scoreViewModel,
    required this.caseId,
  })  : _getCase        = getCase,
        _resetCase      = resetCase,
        _scoreRepository = scoreRepository,
        _scoreViewModel  = scoreViewModel,
        super(CaseOverviewState.initial());

  Future<void> load() async {
    if (kDebugMode) print('▶ CaseOverviewCubit.load() caseId=$caseId');
    try {
      final caseEntity = await _getCase(caseId);
      if (kDebugMode) print('✅ caseEntity loaded: ${caseEntity.title}');

      final progress = await _scoreRepository.getCaseProgress(caseId);
      if (kDebugMode) print('✅ progress loaded: ${progress?.completed}');

      emit(state.copyWith(
        isLoading:     false,
        caseEntity:    caseEntity,
        isCompleted:   progress?.completed ?? false,
        previousScore: progress?.caseScore ?? 0,
      ));
    } catch (e, st) {
      if (kDebugMode) {
        print('❌ CaseOverviewCubit.load() ERROR: $e');
        print(st);
      }
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> resetCase() async {
    try {
      await _scoreViewModel.resetCase(caseId);
      final progress = await _scoreRepository.getCaseProgress(caseId);
      await _resetCase(caseId);
      emit(state.copyWith(isCompleted: false, previousScore: progress?.caseScore));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
