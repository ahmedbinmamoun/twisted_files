import 'package:twisted_files/features/rank_screen/data/data_sources/rank_remote_data_source.dart';
import 'package:twisted_files/features/rank_screen/domain/entities/rank_entry_entity.dart';
import 'package:twisted_files/features/rank_screen/domain/repositories/rank_repository.dart';

class RankRepositoryImpl implements RankRepository {
  final RankRemoteDataSource _remote;
  const RankRepositoryImpl(this._remote);

  @override
  Future<List<RankEntryEntity>> getLeaderboard() async {
    final rows       = await _remote.fetchLeaderboard();
    final currentUid = _remote.currentUserId;

    return rows.asMap().entries.map((entry) {
      final rank       = entry.key + 1;
      final row        = entry.value;
      final profileMap = row['profiles'] as Map<String, dynamic>?;
      final nickname   = profileMap?['nickname'] as String? ?? 'Detective';

      return RankEntryEntity(
        rank:          rank,
        userId:        row['user_id'] as String,
        nickname:      nickname,
        totalScore:    (row['total_score'] as num?)?.toInt() ?? 0,
        isCurrentUser: row['user_id'] == currentUid,
      );
    }).toList();
  }

  @override
  Future<int> getUserRank() => _remote.fetchUserRank();
}
