import 'package:twisted_files/data/models/evidence_model.dart';
import 'package:twisted_files/data/models/qustion_model.dart';
import 'package:twisted_files/data/models/suspect_model.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';

class CaseModel {
  final String id;
  final String caseNumber;
  final String location;
  final String difficulty;
  final String title;
  final String summary;
  final String date;
  final List<EvidenceModel> evidences;
  final List<SuspectModel> suspects;
  final List<QuestionModel> questions;

  CaseModel({
    required this.id,
    required this.caseNumber,
    required this.location,
    required this.difficulty,
    required this.title,
    required this.summary,
    required this.evidences,
    required this.suspects,
    required this.questions,
    required this.date
  });

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      id: json['id'],
      caseNumber: json['case_number'],
      location: json['location'],
      difficulty: json['difficulty'],
      title: json['title'],
      date: json['date'],
      summary: json['case_file']['summary'],
      evidences: (json['evidences'] as List)
          .map((e) => EvidenceModel.fromJson(e))
          .toList(),
      suspects: (json['suspects'] as List)
          .map((s) => SuspectModel.fromJson(s))
          .toList(),
      questions: (json['questions'] as List)
          .map((s) => QuestionModel.fromJson(s))
          .toList(),
    );
  }

  CaseEntity toEntity() {
    return CaseEntity(
      id: id,
      caseNumber: caseNumber,
      location: location,
      difficulty: difficulty,
      title: title,
      date: date,
      summary: summary,
      evidences: evidences.map((e) => e.toEntity()).toList(),
      suspects: suspects.map((s) => s.toEntity()).toList(),
      questions: questions.map((s) => s.toEntity()).toList(),
    );
  }
}