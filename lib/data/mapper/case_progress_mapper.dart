import 'package:twisted_files/domain/entities/case_progress_entity.dart';
import 'package:twisted_files/data/models/case_progress_model.dart';

class CaseProgressMapper {
  static CaseProgressModel toModel(CaseProgressEntity entity) {
    return CaseProgressModel(
      caseId: entity.caseId,
      difficulty: entity.difficulty,
      completed: entity.completed,
      caseScore: entity.caseScore,
    );
  }

  static CaseProgressEntity toEntity(CaseProgressModel model) {
    return CaseProgressEntity(
      caseId: model.caseId,
      difficulty: model.difficulty,
      completed: model.completed,
      caseScore: model.caseScore,
    );
  }
}