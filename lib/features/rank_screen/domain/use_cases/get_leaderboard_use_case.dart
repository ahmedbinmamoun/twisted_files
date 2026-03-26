import 'package:twisted_files/features/rank_screen/domain/entities/rank_entry_entity.dart';
import 'package:twisted_files/features/rank_screen/domain/repositories/rank_repository.dart';

/// SRP: Only fetches and returns the ranked leaderboard list.
class GetLeaderboardUseCase {
  final RankRepository _repository;
  const GetLeaderboardUseCase(this._repository);

  Future<List<RankEntryEntity>> call() => _repository.getLeaderboard();
}
