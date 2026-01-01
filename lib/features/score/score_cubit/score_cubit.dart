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

  ScoreCubit(this.updateScoreUseCase, this.repository)
      : super(ScoreState(ScoreEntity(totalScore: 0, questionPoints: 0, suspectPoints: 0))) {
    _loadScore();
  }

  Future<void> _loadScore() async {
    final saved = await repository.getScore();
    emit(ScoreState(saved));
  }

  Future<void> answerQuestion(CaseEntity caseEntity, bool isCorrect) async {
    final updated = await updateScoreUseCase.call(
      currentScore: state.score,
      solvedQuestion: isCorrect,
      solvedSuspect: false,
      wrongQuestion: !isCorrect,
      caseEntity: caseEntity,
    );
    emit(ScoreState(updated));
  }

  Future<void> solveSuspect(CaseEntity caseEntity) async {
    final updated = await updateScoreUseCase.call(
      currentScore: state.score,
      solvedQuestion: false,
      solvedSuspect: true,
      wrongQuestion: false,
      caseEntity: caseEntity,
    );
    emit(ScoreState(updated));
  }
}