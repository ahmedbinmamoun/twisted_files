import 'package:twisted_files/features/profile_screen/domain/entities/profile_stats_entity.dart';
import 'package:twisted_files/features/score/domain/entities/score_entity.dart';

abstract class ProfileRepository {
  Future<ScoreEntity> getScore();
  Future<ProfileStatsEntity> getProfileStats();
}
