import 'package:twisted_files/features/rank_screen/domain/repositories/rank_repository.dart';

/// SRP: Only fetches the current user's position in the leaderboard.
class GetUserRankUseCase {
  final RankRepository _repository;
  const GetUserRankUseCase(this._repository);

  /// Returns rank (1-based). Returns 0 if user has no score yet.
  Future<int> call() => _repository.getUserRank();
}
