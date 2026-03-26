import 'package:twisted_files/features/profile_screen/domain/entities/profile_stats_entity.dart';

class ProfileState {
  final bool isLoading;
  final int  totalScore;
  final int  userRank;       // ← real rank from leaderboard
  final ProfileStatsEntity stats;

  const ProfileState({
    required this.isLoading,
    required this.totalScore,
    required this.userRank,
    required this.stats,
  });

  factory ProfileState.initial() => ProfileState(
    isLoading:  true,
    totalScore: 0,
    userRank:   0,     // 0 = not loaded yet
    stats:      ProfileStatsEntity.empty(),
  );

  ProfileState copyWith({
    bool?                isLoading,
    int?                 totalScore,
    int?                 userRank,
    ProfileStatsEntity?  stats,
  }) => ProfileState(
    isLoading:  isLoading  ?? this.isLoading,
    totalScore: totalScore ?? this.totalScore,
    userRank:   userRank   ?? this.userRank,
    stats:      stats      ?? this.stats,
  );
}
