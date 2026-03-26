import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/repositories/case_repository.dart';

class GetCasesByDifficultyUseCase {
  final CaseRepository _repository;
  const GetCasesByDifficultyUseCase(this._repository);

  Future<List<CaseEntity>> call(String difficulty) =>
      _repository.getCasesByDifficulty(difficulty);
}
