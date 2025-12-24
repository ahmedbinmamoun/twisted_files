import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/domain/entities/evidence_entity.dart';
import 'package:twisted_files/domain/entities/suspect_entity.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/features/investigation/cubit/investigation_state.dart';

class InvestigationCubit extends Cubit<InvestigationState> {
  final CaseRepository repository;

  InvestigationCubit(this.repository) : super(InvestigationInitial());

  Future<void> loadCase(String caseId) async {
    try {
      emit(InvestigationLoading());
      final caseEntity = await repository.getCase(caseId);
      emit(InvestigationLoaded(caseEntity));
    } catch (e) {
      emit(InvestigationError(e.toString()));
    }
  }

  EvidenceEntity getEvidenceById(String id) {
    final caseEntity = state is InvestigationLoaded
        ? (state as InvestigationLoaded).caseEntity
        : throw Exception('Case not loaded');
    return caseEntity.evidences.firstWhere((e) => e.id == id);
  }

  SuspectEntity getSuspectById(String id) {
    final caseEntity = state is InvestigationLoaded
        ? (state as InvestigationLoaded).caseEntity
        : throw Exception('Case not loaded');
    return caseEntity.suspects.firstWhere((s) => s.id == id);
  }
}