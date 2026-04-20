import 'package:twisted_files/features/cases_list_screen/data/data_sources/case_local_data_source.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/repositories/case_repository.dart';

class CaseRepositoryImpl implements CaseRepository {
  final CaseLocalDataSource _dataSource;
  const CaseRepositoryImpl(this._dataSource);

  @override
  Future<CaseEntity> getCase(String caseId) async {
    final model = await _dataSource.loadCase(caseId);
    return model.toEntity();
  }

  @override
  Future<List<CaseEntity>> getAllCases() async {
    final models = await _dataSource.loadAllCases();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
Future<List<CaseEntity>> getCasesByDifficulty(
  String difficulty, {
  int page     = 0,
  int pageSize = 6,
}) async {
  final models = await _dataSource.loadAllCases();
  final filtered = models
      .where((m) => m.difficulty == difficulty)
      .toList();

  final from = page * pageSize;
  if (from >= filtered.length) return [];
  final to = (from + pageSize).clamp(0, filtered.length);

  return filtered.sublist(from, to).map((m) => m.toEntity()).toList();
}
}
