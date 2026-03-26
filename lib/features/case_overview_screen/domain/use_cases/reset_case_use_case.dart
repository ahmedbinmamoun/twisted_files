import 'package:twisted_files/features/score/domain/repositories/score_repository.dart';

class ResetCaseUseCase {
  final ScoreRepository _repository;
  const ResetCaseUseCase(this._repository);
  Future<void> call(String caseId) => _repository.resetCase(caseId);
}
