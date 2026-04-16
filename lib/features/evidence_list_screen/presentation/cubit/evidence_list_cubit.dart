import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/features/cases_list_screen/domain/repositories/case_repository.dart';
import 'evidence_list_state.dart';

class EvidenceListCubit extends Cubit<EvidenceListState> {
  final CaseRepository _repository;
  final String caseId;

  EvidenceListCubit({required CaseRepository repository, required this.caseId})
      : _repository = repository,
        super(EvidenceListLoading());

  Future<void> loadCase() async {
    try {
      final caseEntity = await _repository.getCase(caseId);
      emit(EvidenceListLoaded(caseEntity));
    } catch (e) {
      emit(EvidenceListError(e.toString()));
    }
  }
}
