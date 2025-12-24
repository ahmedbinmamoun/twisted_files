import 'package:twisted_files/data/models/evidence_model.dart';
import 'package:twisted_files/data/models/suspect_model.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';

class CaseModel {
  final String id;
  final String caseNumber;
  final String location;
  final String difficulty;
  final String title;
  final String summary;
  final List<EvidenceModel> evidences;
  final List<SuspectModel> suspects;

  CaseModel({
    required this.id,
    required this.caseNumber,
    required this.location,
    required this.difficulty,
    required this.title,
    required this.summary,
    required this.evidences,
    required this.suspects,
  });

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      id: json['id'],
      caseNumber: json['case_number'],
      location: json['location'],
      difficulty: json['difficulty'],
      title: json['title'],
      summary: json['case_file']['summary'],
      evidences: (json['evidences'] as List)
          .map((e) => EvidenceModel.fromJson(e))
          .toList(),
      suspects: (json['suspects'] as List)
          .map((s) => SuspectModel.fromJson(s))
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
      summary: summary,
      evidences: evidences.map((e) => e.toEntity()).toList(),
      suspects: suspects.map((s) => s.toEntity()).toList(),
    );
  }
}