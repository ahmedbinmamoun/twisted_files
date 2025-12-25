import 'package:twisted_files/domain/entities/question_entity.dart';

import 'evidence_entity.dart';
import 'suspect_entity.dart';

class CaseEntity {
  final String id;
  final String caseNumber;
  final String location;
  final String difficulty;
  final String title;
  final String summary;
  final String date;

  final List<EvidenceEntity> evidences;
  final List<SuspectEntity> suspects;
  final List<QuestionEntity> questions;

  CaseEntity({
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
}