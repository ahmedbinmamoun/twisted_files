import 'package:twisted_files/domain/entities/case_difficulty_entity.dart';
import 'package:twisted_files/domain/entities/case_progress_entity.dart';

class CaseProgressModel extends CaseProgressEntity {
  CaseProgressModel({required super.caseId, required super.completed, required super.caseScore, required super.difficulty});
  
  factory CaseProgressModel.fromJson(Map<String, dynamic> json) {
    return CaseProgressModel(
      caseId: json['caseId'],
       completed: json['completed'],
        caseScore: json['caseScore'],
         difficulty: _parseDifficulty(json['difficulty'] as String),
         );
  }

  Map<String, dynamic> toJson(){
    return {
      'caseId' : caseId,
      'difficulty' : _difficultyToString(difficulty),
      'completed' : completed,
      'caseScore' : caseScore
    };
  }

  static String _difficultyToString(CaseDifficultyEntity difficulty) {
    switch (difficulty) {
      case CaseDifficultyEntity.easy:
        return 'easy';
      case CaseDifficultyEntity.medium:
        return 'medium';
      case CaseDifficultyEntity.hard:
        return 'hard';
    }
  }

  static CaseDifficultyEntity _parseDifficulty(String? value) {
    if (value == null) return CaseDifficultyEntity.easy;
    switch (value.toLowerCase()) {
      case 'easy':
        return CaseDifficultyEntity.easy;
      case 'medium':
      case 'normal':
        return CaseDifficultyEntity.medium;
      case 'hard':
      case 'difficult':
        return CaseDifficultyEntity.hard;
      default:
        return CaseDifficultyEntity.easy;
    }
  }
}