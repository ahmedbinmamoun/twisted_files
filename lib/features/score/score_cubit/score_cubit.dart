import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/entities/case_progress_entity.dart';
import 'package:twisted_files/domain/entities/score_entity.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';
import 'package:twisted_files/domain/use_cases/update_score_use_case.dart';

class ScoreState {
  final ScoreEntity score;
  final bool isCaseCompleted;
  final int previousCaseScore;

  const ScoreState({
    required this.score,
    this.isCaseCompleted = false,
    this.previousCaseScore = 0,
  });

  ScoreState copyWith({
    ScoreEntity? score,
    bool? isCaseCompleted,
    int? previousCaseScore,
  }) {
    return ScoreState(
      score: score ?? this.score,
      isCaseCompleted: isCaseCompleted ?? this.isCaseCompleted,
      previousCaseScore: previousCaseScore ?? this.previousCaseScore,
    );
  }
}

class ScoreCubit extends Cubit<ScoreState> {
  final ScoreRepository repository;
  final UpdateScoreUseCase useCase;
  final String? activeCaseId;

  int _sessionStartTotal = 0;

  ScoreCubit({
    required this.useCase,
    required this.repository,
    this.activeCaseId,
  }) : super(
          ScoreState(
            score: ScoreEntity(
              totalScore: 0,
              questionPoints: 0,
              suspectPoints: 0,
            ),
          ),
        ) {
    _init();
  }

  Future<void> _init() async {
    final globalScore = await repository.getScore();
    _sessionStartTotal = globalScore.totalScore;

    if (activeCaseId == null) {
      emit(state.copyWith(score: globalScore));
      return;
    }

    final progress = await repository.getCaseProgress(activeCaseId!);

    emit(
      state.copyWith(
        score: globalScore,
        isCaseCompleted: progress?.completed ?? false,
        previousCaseScore: progress?.caseScore ?? 0,
      ),
    );
  }

  // ---------------- QUESTIONS ----------------
  Future<void> answerQuestion(CaseEntity caseEntity, bool isCorrect) async {
    if (state.isCaseCompleted) return;

    final updatedScore = await useCase.call(
      currentScore: state.score,
      solvedQuestion: isCorrect,
      solvedSuspect: false,
      wrongQuestion: !isCorrect,
      caseEntity: caseEntity,
    );

    emit(state.copyWith(score: updatedScore));
  }

  // ---------------- SUSPECT ----------------
  Future<void> solveSuspect(CaseEntity caseEntity, bool isCorrect) async {
    if (state.isCaseCompleted) return;

    final updatedScore = await useCase.call(
      currentScore: state.score,
      solvedQuestion: false,
      solvedSuspect: isCorrect,
      wrongQuestion: !isCorrect,
      caseEntity: caseEntity,
    );

    emit(state.copyWith(score: updatedScore));
  }

  // ---------------- FINALIZE CASE ----------------
  Future<void> finalizeCase(CaseEntity caseEntity) async {
    if (state.isCaseCompleted || activeCaseId == null) return;

    final sessionGain = state.score.totalScore - _sessionStartTotal;

    await repository.saveCaseProgress(
      CaseProgressEntity(
        caseId: activeCaseId!,
        completed: true,
        caseScore: sessionGain,
      ),
    );

    await repository.saveScore(state.score);

    emit(state.copyWith(
      isCaseCompleted: true,
      previousCaseScore: sessionGain,
    ));

    _sessionStartTotal = state.score.totalScore;
  }

  // ---------------- RESET CASE ----------------
  Future<void> resetCase(CaseEntity caseEntity) async {
    if (activeCaseId == null) return;

    final progress = await repository.getCaseProgress(activeCaseId!);
    if (progress == null || !progress.completed) return;

    final oldScore = progress.caseScore;
    final newTotal = state.score.totalScore - oldScore;

    await repository.resetCase(activeCaseId!);

    final resetScore = state.score.copyWith(
      totalScore: newTotal,
      questionPoints: 0,
      suspectPoints: 0,
    );

    await repository.saveScore(resetScore);

    emit(state.copyWith(
      score: resetScore,
      isCaseCompleted: false,
      previousCaseScore: 0,
    ));

    _sessionStartTotal = newTotal;
  }
}