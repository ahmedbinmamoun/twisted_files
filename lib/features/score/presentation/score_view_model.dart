import 'package:flutter/foundation.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_difficulty_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_progress_entity.dart';
import 'package:twisted_files/features/score/domain/entities/score_entity.dart';
import 'package:twisted_files/features/score/domain/repositories/score_repository.dart';
import 'package:twisted_files/features/score/domain/use_cases/update_score_use_case.dart';

/// SRP: Manages only score state for the UI.
/// Injected as a singleton via DI so all screens share the same score state.
class ScoreViewModel extends ChangeNotifier {
  final UpdateScoreUseCase _updateScoreUseCase;
  final ScoreRepository _repository;

  ScoreEntity _score = ScoreEntity(totalScore: 0, questionPoints: 0, suspectPoints: 0);
  bool _loading = false;
  String? _currentCaseSessionId;
  int _sessionStartTotal    = 0;
  int _sessionPenalty       = 0;
  int _sessionQuestionGross = 0;
  int _sessionSolvedCount   = 0;
  int _sessionSuspectGross  = 0;
  late final Future<void> _initialized;

  ScoreViewModel(this._updateScoreUseCase, this._repository) {
    _initialized = loadScore();
  }

  ScoreEntity get score            => _score;
  bool        get loading          => _loading;
  int         get sessionPenalty       => _sessionPenalty;
  int         get sessionQuestionGross => _sessionQuestionGross;
  int         get sessionSolvedCount   => _sessionSolvedCount;
  int         get sessionSuspectGross  => _sessionSuspectGross;

  Future<void> loadScore() async {
    _loading = true;
    notifyListeners();
    final saved  = await _repository.getScore();
    final cases  = await _repository.getAllCompletedCases();
    final sumCase = cases.fold<int>(0, (p, e) => p + e.caseScore);

    int authoritative = saved.totalScore;
    if (sumCase > authoritative) {
      authoritative = sumCase;
      await _repository.saveScore(
        ScoreEntity(totalScore: authoritative, questionPoints: 0, suspectPoints: 0),
      );
    }
    _score = ScoreEntity(totalScore: authoritative, questionPoints: 0, suspectPoints: 0);
    _sessionStartTotal = authoritative;
    _loading = false;
    notifyListeners();
  }

  Future<void> startCaseSession(String caseId) async {
    await _initialized;
    if (_currentCaseSessionId == caseId) return;
    final progress          = await _repository.getCaseProgress(caseId);
    final previousCaseScore = progress?.caseScore ?? 0;
    final saved             = await _repository.getScore();
    final baseline          = (saved.totalScore - previousCaseScore).clamp(0, double.infinity).toInt();
    _score                  = ScoreEntity(totalScore: baseline, questionPoints: 0, suspectPoints: 0);
    _sessionPenalty         = 0;
    _sessionQuestionGross   = 0;
    _sessionSolvedCount     = 0;
    _sessionSuspectGross    = 0;
    _sessionStartTotal      = baseline;
    _currentCaseSessionId   = caseId;
    notifyListeners();
  }

  Future<void> answerQuestion(CaseEntity caseEntity, bool isCorrect) async {
    final updated    = await _updateScoreUseCase(
      currentScore: _score,
      solvedQuestion: isCorrect,
      solvedSuspect: false,
      wrongQuestion: !isCorrect,
      caseEntity: caseEntity,
    );
    final multiplier = _multiplier(caseEntity.difficulty);
    if (isCorrect) { _sessionSolvedCount++; _sessionQuestionGross += 10 * multiplier; }
    else           { _sessionPenalty += 20 * multiplier; }
    _score = updated;
    notifyListeners();
  }

  Future<void> solveSuspect(CaseEntity caseEntity) async {
    final updated    = await _updateScoreUseCase(
      currentScore: _score,
      solvedQuestion: false,
      solvedSuspect: true,
      wrongQuestion: false,
      caseEntity: caseEntity,
    );
    _sessionSuspectGross += 50 * _multiplier(caseEntity.difficulty);
    _score = updated;
    notifyListeners();
  }

  Future<void> finalizeCase(CaseEntity caseEntity, {bool isCorrect = true}) async {
    if (!isCorrect) _sessionSuspectGross = 0;
    final sessionGain = (_sessionQuestionGross - _sessionPenalty + _sessionSuspectGross)
        .clamp(0, double.infinity).toInt();
    final saved          = await _repository.getScore();
    final prev           = await _repository.getCaseProgress(caseEntity.id);
    final prevScore      = prev?.caseScore ?? 0;
    final newTotal       = (saved.totalScore - prevScore + sessionGain).clamp(0, double.infinity).toInt();
    final difficulty     = _parseDiff(caseEntity.difficulty);

    await _repository.saveCaseProgress(CaseProgressEntity(
      caseId: caseEntity.id,
      completed: true,
      caseScore: sessionGain,
      difficulty: difficulty,
    ));
    _score = ScoreEntity(totalScore: newTotal, questionPoints: _score.questionPoints, suspectPoints: _score.suspectPoints);
    await _repository.saveScore(_score);
    _sessionStartTotal      = newTotal;
    _currentCaseSessionId   = null;
    _sessionQuestionGross   = 0;
    _sessionPenalty         = 0;
    _sessionSolvedCount     = 0;
    _sessionSuspectGross    = 0;
    notifyListeners();
  }

  Future<void> resetCase(String caseId) async {
  await _repository.resetCase(caseId);

  _score = ScoreEntity(
    totalScore:    _sessionStartTotal, 
    questionPoints: 0,
    suspectPoints:  0,
  );

  await _repository.saveScore(_score);

  _currentCaseSessionId = null;
  _sessionPenalty       = 0;
  _sessionQuestionGross = 0;
  _sessionSolvedCount   = 0;
  _sessionSuspectGross  = 0;

  notifyListeners();
}

  int _multiplier(dynamic diff) {
    switch (_parseDiff(diff)) {
      case CaseDifficultyEntity.easy:   return 1;
      case CaseDifficultyEntity.medium: return 2;
      case CaseDifficultyEntity.hard:   return 3;
    }
  }

  CaseDifficultyEntity _parseDiff(dynamic diff) {
    if (diff is CaseDifficultyEntity) return diff;
    if (diff is String) {
      switch (diff.toLowerCase()) {
        case 'easy':   return CaseDifficultyEntity.easy;
        case 'medium':
        case 'normal': return CaseDifficultyEntity.medium;
        case 'hard':
        case 'difficult': return CaseDifficultyEntity.hard;
      }
    }
    return CaseDifficultyEntity.easy;
  }
}
