import 'package:twisted_files/domain/entities/case_entity.dart';

abstract class InvestigationState {}

class InvestigationInitial extends InvestigationState {}

class InvestigationLoading extends InvestigationState {}

class InvestigationLoaded extends InvestigationState {
  final CaseEntity caseEntity;

  InvestigationLoaded(this.caseEntity);
}

class InvestigationError extends InvestigationState {
  final String message;

  InvestigationError(this.message);
}