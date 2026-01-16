import 'package:twisted_files/domain/entities/case_entity.dart';

abstract class EvidenceListState {}

class EvidenceListLoading extends EvidenceListState {}

class EvidenceListLoaded extends EvidenceListState {
  final CaseEntity caseEntity;
  EvidenceListLoaded(this.caseEntity);
}

class EvidenceListError extends EvidenceListState {
  final String message;
  EvidenceListError(this.message);
}