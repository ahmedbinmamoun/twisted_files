abstract class LocalScoreDataSource {
  Future<int> getScore();
  Future<void> saveScore(int score);
  Future<int> getCaseScore(String caseId);
  Future<void> saveCaseScore(String caseId, int score);
}