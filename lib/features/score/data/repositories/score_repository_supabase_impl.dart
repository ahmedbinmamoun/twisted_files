import 'package:twisted_files/features/cases_list_screen/data/models/case_progress_model.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_progress_entity.dart';
import 'package:twisted_files/features/score/data/data_sources/score_remote_data_source.dart';
import 'package:twisted_files/features/score/domain/entities/score_entity.dart';
import 'package:twisted_files/features/score/domain/repositories/score_repository.dart';

/// OCP: Replaces the SharedPreferences impl without changing the abstract contract.
class ScoreRepositorySupabaseImpl implements ScoreRepository {
  final ScoreRemoteDataSource _remote;

  const ScoreRepositorySupabaseImpl(this._remote);

  @override
  Future<ScoreEntity> getScore() async {
    final total = await _remote.getScore();
    return ScoreEntity(totalScore: total, questionPoints: 0, suspectPoints: 0);
  }

  @override
  Future<void> saveScore(ScoreEntity score) async =>
      await _remote.saveScore(score.totalScore);

  @override
  Future<void> saveCaseProgress(CaseProgressEntity entity) async {
    await _remote.saveCaseProgress(CaseProgressModel.fromEntity(entity));
  }

  @override
  Future<void> resetCase(String caseId) async =>
      await _remote.resetCase(caseId);

  @override
  Future<List<CaseProgressEntity>> getAllCompletedCases() async {
    final models = await _remote.getAllCompletedCases();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<CaseProgressEntity?> getCaseProgress(String caseId) async {
    final all = await _remote.getAllCompletedCases();
    try {
      return all.firstWhere((m) => m.caseId == caseId).toEntity();
    } catch (_) {
      return null;
    }
  }
}
