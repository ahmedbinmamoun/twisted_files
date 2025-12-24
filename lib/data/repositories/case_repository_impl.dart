import 'package:twisted_files/data/data_source/local_case_data_source.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';

class CaseRepositoryImpl implements CaseRepository {
  final LocalCaseDataSource localDataSource;

  CaseRepositoryImpl(this.localDataSource);

  @override
  Future<CaseEntity> getCase(String caseId) async {
    final model = await localDataSource.loadCase(caseId);
    return model.toEntity();
  }
}