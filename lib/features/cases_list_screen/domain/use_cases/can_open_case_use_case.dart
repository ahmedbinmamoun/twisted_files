import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';

/// SRP: Only checks if the player has enough score to open a case.
class CanOpenCaseUseCase {
  const CanOpenCaseUseCase();

  bool call({required int totalScore, required CaseEntity caseEntity}) =>
      totalScore >= caseEntity.unlockRole.requiredScore;
}
