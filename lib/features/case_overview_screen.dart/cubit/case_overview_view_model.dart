import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';
import 'package:twisted_files/features/case_overview_screen.dart/cubit/case_overview_state.dart';

class CaseOverviewViewModel extends Cubit<CaseOverviewState> {
  final String caseId;
  final CaseRepository caseRepository;
  final ScoreRepository scoreRepository;

  CaseOverviewViewModel({
    required this.caseId,
    required this.caseRepository,
    required this.scoreRepository,
  }) : super(CaseOverviewState.initial());

  Future<void> load() async {
    try {
      final caseEntity = await caseRepository.getCase(caseId);
      final progress = await scoreRepository.getCaseProgress(caseId);

      emit(
        state.copyWith(
          isLoading: false,
          caseEntity: caseEntity,
          isCompleted: progress?.completed ?? false,
          previousScore: progress?.caseScore ?? 0,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> resetCase() async {
    await scoreRepository.resetCase(caseId);
    emit(state.copyWith(isCompleted: false, previousScore: 0));
  }
}