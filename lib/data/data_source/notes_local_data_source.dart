abstract class  NotesLocalDataSource {
  Future<String?> getNote(String caseId);
  Future<void> saveNote(String caseId, String note);
  
}