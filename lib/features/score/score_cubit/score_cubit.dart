import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/entities/score_entity.dart';
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
      : super(ScoreState(ScoreEntity(totalScore: 0, questionPoints: 0, suspectPoints: 0))){
        _loadScore();
      }


  Future<void> _loadScore() async {
    final saved = await repository.getScore();
    emit(ScoreState(saved));
  }

  Future<void> solveQuestion(CaseEntity caseEntity) async {
    final updatedScore = await updateScoreUseCase(
      currentScore: state.score,
      solvedQuestion: true,
      solvedSuspect: false,
      caseEntity: caseEntity,
    );
    emit(ScoreState(updatedScore));
  }

  Future<void> solveSuspect(CaseEntity caseEntity) async {
    final updatedScore = await updateScoreUseCase(
      currentScore: state.score,
      solvedQuestion: false,
      solvedSuspect: true,
      caseEntity: caseEntity,
    );
    emit(ScoreState(updatedScore));
  }

  Future<void> resetScore() async {
    final resetScore = await updateScoreUseCase.call(
      currentScore: ScoreEntity(totalScore: 0, questionPoints: 0, suspectPoints: 0),
      solvedQuestion: false,
      solvedSuspect: false,
      caseEntity: CaseEntity.empty(), 
    );
    emit(ScoreState(resetScore));
  }
}