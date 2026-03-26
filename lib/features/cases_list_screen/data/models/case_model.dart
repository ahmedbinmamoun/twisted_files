import 'package:twisted_files/features/cases_list_screen/data/models/evidence_model.dart';
import 'package:twisted_files/features/cases_list_screen/data/models/question_model.dart';
import 'package:twisted_files/features/cases_list_screen/data/models/suspect_model.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_difficulty_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_unlock_role_entity.dart';

class CaseModel {
  final String id;
  final String caseNumber;
  final String location;
  final String difficulty;
  final String title;
  final String summary;
  final String date;
  final String correctSuspectId;
  final int requiredScore;
  final List<EvidenceModel> evidences;
  final List<SuspectModel> suspects;
  final List<QuestionModel> questions;

  const CaseModel({
    required this.id,
    required this.caseNumber,
    required this.location,
    required this.difficulty,
    required this.title,
    required this.summary,
    required this.evidences,
    required this.suspects,
    required this.questions,
    required this.date,
    required this.correctSuspectId,
    required this.requiredScore,
  });

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    // ✅ null-safe access لـ case_file
    final caseFile = json['case_file'] as Map<String, dynamic>?;
    final summary  = caseFile?['summary'] as String? ?? '';

    return CaseModel(
      id:              json['id']?.toString() ?? '',
      caseNumber:      json['case_number']?.toString() ?? '',
      location:        json['location']?.toString() ?? '',
      difficulty:      json['difficulty']?.toString() ?? 'easy',
      title:           json['title']?.toString() ?? '',
      date:            json['date']?.toString() ?? '',
      correctSuspectId: json['correct_suspect_id']?.toString() ?? '',
      summary:         summary,
      requiredScore:   (json['required_score'] as num?)?.toInt() ?? 0,
      evidences: ((json['evidences'] as List?) ?? [])
          .map((e) => EvidenceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      suspects: ((json['suspects'] as List?) ?? [])
          .map((e) => SuspectModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      questions: ((json['questions'] as List?) ?? [])
          .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  CaseEntity toEntity() => CaseEntity(
    id:              id,
    caseNumber:      caseNumber,
    location:        location,
    difficulty:      _mapDifficulty(difficulty),
    title:           title,
    date:            date,
    summary:         summary,
    correctSuspectId: correctSuspectId,
    unlockRole:      CaseUnlockRoleEntity(requiredScore: requiredScore),
    evidences:  evidences.map((e) => e.toEntity()).toList(),
    suspects:   suspects.map((e) => e.toEntity()).toList(),
    questions:  questions.map((e) => e.toEntity()).toList(),
  );

  CaseDifficultyEntity _mapDifficulty(String d) {
    switch (d.toLowerCase()) {
      case 'medium': return CaseDifficultyEntity.medium;
      case 'hard':   return CaseDifficultyEntity.hard;
      default:       return CaseDifficultyEntity.easy;
    }
  }
}
