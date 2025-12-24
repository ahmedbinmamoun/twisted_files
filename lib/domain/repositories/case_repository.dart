import 'package:twisted_files/domain/entities/case_entity.dart';

abstract class CaseRepository {
  Future<CaseEntity> getCase(String caseId);
}