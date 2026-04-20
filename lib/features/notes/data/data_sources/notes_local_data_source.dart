import 'package:shared_preferences/shared_preferences.dart';
import 'package:twisted_files/features/notes/domain/repositories/notes_repository.dart';

class NotesLocalDataSource implements NotesRepository {
  String _key(String caseId) => 'notes_case_$caseId';

  @override
  Future<String?> getNote(String caseId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key(caseId));
  }

  @override
  Future<void> saveNote(String caseId, String note) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(caseId), note);
  }
}
