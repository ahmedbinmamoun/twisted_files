import 'package:twisted_files/domain/entities/score_entity.dart';

abstract class ScoreRepository {
  Future<ScoreEntity> getScore();
  Future<void> saveScore(ScoreEntity score);
}