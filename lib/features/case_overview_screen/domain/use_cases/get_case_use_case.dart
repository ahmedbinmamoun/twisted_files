import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/repositories/case_repository.dart';

class GetCaseUseCase {
  final CaseRepository _repository;
  const GetCaseUseCase(this._repository);
  Future<CaseEntity> call(String caseId) => _repository.getCase(caseId);
}
