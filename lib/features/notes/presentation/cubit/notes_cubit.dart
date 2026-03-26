import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/features/notes/domain/repositories/notes_repository.dart';

class NotesState {
  final String text;
  const NotesState(this.text);
}

class NotesCubit extends Cubit<NotesState> {
  final NotesRepository _repository;
  final String caseId;

  NotesCubit({required NotesRepository repository, required this.caseId})
      : _repository = repository,
        super(const NotesState('')) {
    _load();
  }

  Future<void> _load() async {
    final note = await _repository.getNote(caseId);
    emit(NotesState(note ?? ''));
  }

  Future<void> updateNote(String value) async {
    emit(NotesState(value));
    await _repository.saveNote(caseId, value);
  }
}
