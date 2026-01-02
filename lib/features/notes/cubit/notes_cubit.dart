import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/data/data_source/notes_local_data_source_impl.dart';

class NotesState {
  final String text;
  NotesState(this.text);
}

class NotesCubit extends Cubit<NotesState> {
  final NotesLocalDataSourceImpl localDataSource;
  final String caseId;

  NotesCubit({
    required this.localDataSource,
    required this.caseId,
  }) : super(NotesState('')) {
    _loadNote();
  }

  Future<void> _loadNote() async {
    final note = await localDataSource.getNote(caseId);
    emit(NotesState(note ?? '')); 
  }

  Future<void> updateNote(String value) async {
    emit(NotesState(value));
    await localDataSource.saveNote(caseId, value);
  }
}
