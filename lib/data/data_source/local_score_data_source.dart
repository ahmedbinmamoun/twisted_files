abstract class LocalScoreDataSource {
  Future<int> getScore();
  Future<void> saveScore(int score);
}