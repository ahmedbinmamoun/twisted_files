import 'package:twisted_files/features/cases_list_screen/domain/entities/case_difficulty_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_progress_entity.dart';

class CaseProgressModel {
  final String caseId;
  final bool completed;
  final int caseScore;
  final CaseDifficultyEntity difficulty;

  const CaseProgressModel({
    required this.caseId,
    required this.completed,
    required this.caseScore,
    required this.difficulty,
  });

  factory CaseProgressModel.fromJson(Map<String, dynamic> json) => CaseProgressModel(
    caseId: json['caseId'],
    completed: json['completed'],
    caseScore: json['caseScore'],
    difficulty: _parseDiff(json['difficulty'] as String?),
  );

  factory CaseProgressModel.fromEntity(CaseProgressEntity e) => CaseProgressModel(
    caseId: e.caseId, completed: e.completed,
    caseScore: e.caseScore, difficulty: e.difficulty,
  );

  Map<String, dynamic> toJson() => {
    'caseId': caseId,
    'difficulty': _diffToString(difficulty),
    'completed': completed,
    'caseScore': caseScore,
  };

  CaseProgressEntity toEntity() => CaseProgressEntity(
    caseId: caseId, completed: completed,
    caseScore: caseScore, difficulty: difficulty,
  );

  static CaseDifficultyEntity _parseDiff(String? v) {
    switch (v?.toLowerCase()) {
      case 'medium':
      case 'normal': return CaseDifficultyEntity.medium;
      case 'hard':
      case 'difficult': return CaseDifficultyEntity.hard;
      default: return CaseDifficultyEntity.easy;
    }
  }

  static String _diffToString(CaseDifficultyEntity d) {
    switch (d) {
      case CaseDifficultyEntity.easy:   return 'easy';
      case CaseDifficultyEntity.medium: return 'medium';
      case CaseDifficultyEntity.hard:   return 'hard';
    }
  }
}
