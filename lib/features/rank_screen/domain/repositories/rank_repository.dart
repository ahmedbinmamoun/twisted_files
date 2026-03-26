import 'package:twisted_files/features/rank_screen/domain/entities/rank_entry_entity.dart';

abstract class RankRepository {
  Future<List<RankEntryEntity>> getLeaderboard();

  /// Returns the 1-based rank of the current user, or 0 if not found.
  Future<int> getUserRank();
}
