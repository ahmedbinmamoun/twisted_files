import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/domain/entities/score_entity.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';
import 'package:twisted_files/domain/use_cases/update_score_use_case.dart';

class ScoreState {
  final ScoreEntity score;
  ScoreState(this.score);
}

class ScoreCubit extends Cubit<ScoreState> {
  final UpdateScoreUseCase updateScoreUseCase;
  final ScoreRepository repository;
  final String? activeCaseId;

  int _sessionStartTotal = 0;

  ScoreCubit(this.updateScoreUseCase, this.repository, {this.activeCaseId})
      : super(ScoreState(ScoreEntity(totalScore: 0, questionPoints: 0, suspectPoints: 0))) {
    _loadScore();
  }

  Future<void> _loadScore() async {
    final saved = await repository.getScore();
    emit(ScoreState(saved));
    _sessionStartTotal = saved.totalScore;
    print('DEBUG: ScoreCubit baseline=$_sessionStartTotal activeCaseId=$activeCaseId');
  }

  Future<void> answerQuestion(CaseEntity caseEntity, bool isCorrect) async {
    final updated = await updateScoreUseCase.call(
      currentScore: state.score,
      solvedQuestion: isCorrect,
      solvedSuspect: false,
      caseEntity: caseEntity, wrongQuestion: !isCorrect,
    );
    emit(ScoreState(updated));
  }

  Future<void> solveSuspect(CaseEntity caseEntity) async {
    final updated = await updateScoreUseCase.call(
      currentScore: state.score,
      solvedQuestion: false,
      solvedSuspect: true,
      caseEntity: caseEntity, wrongQuestion: isClosed,
    );
    emit(ScoreState(updated));
  }

  Future<void> finalizeCase(CaseEntity caseEntity) async {
    final previousCaseScore = await repository.getCaseScore(caseEntity.id);
    final currentTotal = state.score.totalScore;
    final sessionGain = currentTotal - _sessionStartTotal;
    final newTotal = (_sessionStartTotal - previousCaseScore) + sessionGain;

    print('DEBUG: finalizeCase id=${caseEntity.id} prev=$previousCaseScore gain=$sessionGain newTotal=$newTotal');

    await repository.saveCaseScore(caseEntity.id, sessionGain);

    await repository.saveScore(ScoreEntity(
      totalScore: newTotal,
      questionPoints: state.score.questionPoints,
      suspectPoints: state.score.suspectPoints,
    ));

    emit(ScoreState(ScoreEntity(
      totalScore: newTotal,
      questionPoints: state.score.questionPoints,
      suspectPoints: state.score.suspectPoints,
    )));

    _sessionStartTotal = newTotal;
  }
}