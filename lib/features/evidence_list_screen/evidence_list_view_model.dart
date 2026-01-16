import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/features/evidence_list_screen/cubit/evidence_list_state.dart';

class EvidenceListViewModel extends Cubit<EvidenceListState> {
  final String caseId;
  final CaseRepository caseRepository;

  EvidenceListViewModel({
    required this.caseId,
    required this.caseRepository,
  }) : super(EvidenceListLoading());

  Future<void> loadCase() async {
    try {
      final caseEntity = await caseRepository.getCase(caseId);
      emit(EvidenceListLoaded(caseEntity));
    } catch (e) {
      emit(EvidenceListError(e.toString()));
    }
  }
}

