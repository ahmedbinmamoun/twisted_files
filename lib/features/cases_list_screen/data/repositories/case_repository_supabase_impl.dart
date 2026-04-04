import 'package:twisted_files/features/cases_list_screen/data/data_sources/case_remote_data_source.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/repositories/case_repository.dart';

/// OCP: Swaps local asset reading for Supabase remote fetching.
class CaseRepositorySupabaseImpl implements CaseRepository {
  final CaseRemoteDataSource _remote;
  const CaseRepositorySupabaseImpl(this._remote);

  @override
  Future<CaseEntity> getCase(String caseId) async =>
      (await _remote.loadCase(caseId)).toEntity();

  @override
  Future<List<CaseEntity>> getAllCases() async =>
      (await _remote.loadAllCases()).map((m) => m.toEntity()).toList();

  @override
Future<List<CaseEntity>> getCasesByDifficulty(
  String difficulty, {
  int page     = 0,
  int pageSize = 6,
}) async =>
    (await _remote.loadCasesByDifficulty(
      difficulty,
      page:     page,
      pageSize: pageSize,
    ))
        .map((m) => m.toEntity())
        .toList();
}
