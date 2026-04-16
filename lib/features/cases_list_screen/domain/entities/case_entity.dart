import 'package:twisted_files/features/cases_list_screen/domain/entities/case_difficulty_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_unlock_role_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/evidence_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/question_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/suspect_entity.dart';

class CaseEntity {
  final String id;
  final String caseNumber;
  final String location;
  final String title;
  final String summary;
  final String date;
  final String correctSuspectId;
  final CaseDifficultyEntity difficulty;
  final CaseUnlockRoleEntity unlockRole;
  final List<EvidenceEntity> evidences;
  final List<SuspectEntity> suspects;
  final List<QuestionEntity> questions;

  const CaseEntity({
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
    required this.unlockRole,
  });

  factory CaseEntity.empty() => CaseEntity(
    id: '', caseNumber: '', location: '',
    difficulty: CaseDifficultyEntity.easy, title: '', summary: '',
    evidences: [], suspects: [], questions: [], date: '',
    correctSuspectId: '', unlockRole: CaseUnlockRoleEntity.free(),
  );
}
