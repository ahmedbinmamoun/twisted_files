import 'package:flutter/foundation.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/entities/score_entity.dart';
import 'package:twisted_files/domain/entities/case_progress_entity.dart';
import 'package:twisted_files/domain/entities/case_difficulty_entity.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';
import 'package:twisted_files/domain/use_cases/update_score_use_case.dart';

class ScoreViewModel extends ChangeNotifier {
  final UpdateScoreUseCase updateScoreUseCase;
  final ScoreRepository repository;
  final String? activeCaseId;

  ScoreEntity _score = ScoreEntity(totalScore: 0, questionPoints: 0, suspectPoints: 0);
  int _sessionStartTotal = 0;
  bool _loading = false;
  String? _currentCaseSessionId;
  int _sessionPenalty = 0;
  int _sessionQuestionGross = 0;
  int _sessionSolvedCount = 0;
  int _sessionSuspectGross = 0;
  late final Future<void> _initialized;

  ScoreViewModel(this.updateScoreUseCase, this.repository, {this.activeCaseId}) {
  _initialized = loadScore();
  }

  ScoreEntity get score => _score;
  bool get loading => _loading;
  int get sessionPenalty => _sessionPenalty;
  int get sessionQuestionGross => _sessionQuestionGross;
  int get sessionSolvedCount => _sessionSolvedCount;
  int get sessionSuspectGross => _sessionSuspectGross;

  Future<void> loadScore() async {
    _loading = true;
    notifyListeners();
    final saved = await repository.getScore();
    final cases = await repository.getAllCompletedCases();
    final int sumCaseScores = cases.fold<int>(0, (p, e) => p + (e.caseScore));

    int authoritativeTotal = saved.totalScore;
    if (sumCaseScores > authoritativeTotal) {
      authoritativeTotal = sumCaseScores;
      if (kDebugMode) print('ScoreViewModel.loadScore: repair storedTotal from ${saved.totalScore} to $authoritativeTotal because sumCaseScores=$sumCaseScores');
      await repository.saveScore(ScoreEntity(totalScore: authoritativeTotal, questionPoints: 0, suspectPoints: 0));
    }

    _score = ScoreEntity(totalScore: authoritativeTotal, questionPoints: 0, suspectPoints: 0);
    _sessionStartTotal = authoritativeTotal;
    if (kDebugMode) {
      print('ScoreViewModel.loadScore: storedTotal=${authoritativeTotal} sumCaseScores=$sumCaseScores');
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> answerQuestion(CaseEntity caseEntity, bool isCorrect) async {
    final updated = await updateScoreUseCase.call(
      currentScore: _score,
      solvedQuestion: isCorrect,
      solvedSuspect: false,
      wrongQuestion: !isCorrect,
      caseEntity: caseEntity,
    );
    // track gross points and penalties
    final difficulty = _parseDifficulty(caseEntity.difficulty);
    final multiplier = difficulty == CaseDifficultyEntity.easy ? 1 : (difficulty == CaseDifficultyEntity.medium ? 2 : 3);
    if (isCorrect) {
      _sessionSolvedCount += 1;
      _sessionQuestionGross += 10 * multiplier;
    } else {
      final penalty = 20 * multiplier;
      _sessionPenalty += penalty;
    }

    _score = updated; // keep net score for internal computations
    notifyListeners();
  }

  Future<void> solveSuspect(CaseEntity caseEntity) async {
    final updated = await updateScoreUseCase.call(
      currentScore: _score,
      solvedQuestion: false,
      solvedSuspect: true,
      wrongQuestion: false,
      caseEntity: caseEntity,
    );
  // compute suspect points gained for this solve (based on difficulty multiplier)
  final difficulty = _parseDifficulty(caseEntity.difficulty);
  final multiplier = difficulty == CaseDifficultyEntity.easy ? 1 : (difficulty == CaseDifficultyEntity.medium ? 2 : 3);
  final suspectPoints = 50 * multiplier;
  _sessionSuspectGross += suspectPoints;

  _score = updated;
    notifyListeners();
  }

  Future<void> startCaseSession(String caseId) async {
  await _initialized;
    if (_currentCaseSessionId == caseId) return;

    final progress = await repository.getCaseProgress(caseId);
    final previousCaseScore = progress?.caseScore ?? 0;

  final saved = await repository.getScore();
  final savedTotal = saved.totalScore;
  final baseline = (savedTotal - previousCaseScore).clamp(0, double.infinity).toInt();

  final newTotal = baseline;
  _score = ScoreEntity(totalScore: newTotal, questionPoints: 0, suspectPoints: 0);
  _sessionPenalty = 0;
  _sessionQuestionGross = 0;
  _sessionSolvedCount = 0;

  _sessionStartTotal = newTotal;
    _currentCaseSessionId = caseId;
    if (kDebugMode) {
      print('ScoreViewModel.startCaseSession: caseId=$caseId previousCaseScore=$previousCaseScore savedTotal=$savedTotal sessionStartTotal=$_sessionStartTotal currentTotal=${_score.totalScore}');
    }
    notifyListeners();
  }


  CaseDifficultyEntity _parseDifficulty(dynamic diff) {
    if (diff is CaseDifficultyEntity) return diff;
    if (diff is String) {
      switch (diff.toLowerCase()) {
        case 'easy':
          return CaseDifficultyEntity.easy;
        case 'medium':
        case 'normal':
          return CaseDifficultyEntity.medium;
        case 'hard':
        case 'difficult':
          return CaseDifficultyEntity.hard;
        default:
          return CaseDifficultyEntity.easy;
      }
    }
    return CaseDifficultyEntity.easy;
  }

  Future<void> finalizeCase(CaseEntity caseEntity) async {
  // compute sessionGain from tracked gross values so penalties aren't
  // lost due to clamping in UpdateScoreUseCase.
  final int sessionGain = (_sessionQuestionGross - _sessionPenalty + _sessionSuspectGross).clamp(0, double.infinity).toInt();

    // Use authoritative saved total and previous per-case score to compute the
    // new global total so finalize is correct even if startCaseSession was
    // missed.
    final saved = await repository.getScore();
    final savedTotal = saved.totalScore;
    final prevProgress = await repository.getCaseProgress(caseEntity.id);
    final previousCaseScore = prevProgress?.caseScore ?? 0;

    final int newTotal = (savedTotal - previousCaseScore + sessionGain).clamp(0, double.infinity).toInt();

  final difficulty = _parseDifficulty(caseEntity.difficulty);
    final caseProgress = CaseProgressEntity(
      caseId: caseEntity.id,
      completed: true,
      caseScore: sessionGain,
      difficulty: difficulty,
    );

    await repository.saveCaseProgress(caseProgress);

    final savedScore = ScoreEntity(totalScore: newTotal, questionPoints: _score.questionPoints, suspectPoints: _score.suspectPoints);
    _score = savedScore;
    await repository.saveScore(_score);
    _sessionStartTotal = newTotal;
    _currentCaseSessionId = null;
  // reset per-session gross counters
  _sessionQuestionGross = 0;
  _sessionPenalty = 0;
  _sessionSolvedCount = 0;
  _sessionSuspectGross = 0;
    if (kDebugMode) {
      print('ScoreViewModel.finalizeCase: caseId=${caseEntity.id} sessionGain=$sessionGain savedTotal=$savedTotal previousCaseScore=$previousCaseScore newTotal=$newTotal savedCaseScore=${caseProgress.caseScore}');
    }
    notifyListeners();
  }

  Future<void> resetCase(String caseId) async {
  final progress = await repository.getCaseProgress(caseId);
  final previousCaseScore = progress?.caseScore ?? 0;

  await repository.resetCase(caseId);

  final restoredTotal = (_score.totalScore + previousCaseScore).clamp(0, double.infinity).toInt();
  final restored = ScoreEntity(totalScore: restoredTotal, questionPoints: 0, suspectPoints: 0);
  _score = restored;
  await repository.saveScore(_score);
  _currentCaseSessionId = null;
  notifyListeners();
  }
}
