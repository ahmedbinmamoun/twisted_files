import 'package:twisted_files/features/cases_list_screen/data/models/case_progress_model.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_progress_entity.dart';
import 'package:twisted_files/features/score/data/data_sources/score_local_data_source.dart';
import 'package:twisted_files/features/score/domain/entities/score_entity.dart';
import 'package:twisted_files/features/score/domain/repositories/score_repository.dart';

/// OCP: Open for extension (new data sources), closed for modification.
class ScoreRepositoryImpl implements ScoreRepository {
  final ScoreLocalDataSource _dataSource;

  const ScoreRepositoryImpl(this._dataSource);

  @override
  Future<ScoreEntity> getScore() async {
    final total = await _dataSource.getScore();
    return ScoreEntity(totalScore: total, questionPoints: 0, suspectPoints: 0);
  }

  @override
  Future<void> saveScore(ScoreEntity score) async =>
      await _dataSource.saveScore(score.totalScore);

  @override
  Future<void> saveCaseProgress(CaseProgressEntity progress) async {
    await _dataSource.saveCaseProgress(CaseProgressModel.fromEntity(progress));
  }

  @override
  Future<void> resetCase(String caseId) async =>
      await _dataSource.resetCase(caseId);

  @override
  Future<List<CaseProgressEntity>> getAllCompletedCases() async {
    final models = await _dataSource.getAllCompletedCases();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<CaseProgressEntity?> getCaseProgress(String caseId) async {
    final all = await _dataSource.getAllCompletedCases();
    try {
      return all.firstWhere((e) => e.caseId == caseId).toEntity();
    } catch (_) {
      return null;
    }
  }
}
