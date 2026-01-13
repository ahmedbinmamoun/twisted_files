import 'package:twisted_files/domain/entities/case_entity.dart';

class CanOpenCaseUseCase {
  bool call({
    required int totalScore,
    required CaseEntity caseEntity,
  }) {
    return totalScore >= caseEntity.unlockRole.requiredScore;
  }
}