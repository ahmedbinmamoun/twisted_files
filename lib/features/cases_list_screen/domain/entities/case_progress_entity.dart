import 'package:twisted_files/features/cases_list_screen/domain/entities/case_difficulty_entity.dart';

class CaseProgressEntity {
  final String caseId;
  final bool completed;
  final int caseScore;
  final CaseDifficultyEntity difficulty;

  const CaseProgressEntity({
    required this.caseId,
    required this.completed,
    required this.caseScore,
    required this.difficulty,
  });
}
