import 'package:twisted_files/data/data_source/local_score_data_source.dart';
import 'package:twisted_files/domain/entities/score_entity.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';

class ScoreRepositoryImpl implements ScoreRepository {
  final LocalScoreDataSource localDataSource;

  ScoreRepositoryImpl(this.localDataSource);

  @override
  Future<ScoreEntity> getScore() async {
    final score = await localDataSource.getScore();
    return ScoreEntity(totalScore: score, questionPoints: 1, suspectPoints: 2);
  }

  @override
  Future<void> saveScore(ScoreEntity score) async {
    await localDataSource.saveScore(score.totalScore);
  }
}