import 'package:twisted_files/domain/entities/profile_stats_entity.dart';

class ProfileState {
  final bool isLoading;
  final int totalScore;
  final ProfileStatsEntity stats;

  const ProfileState({
    required this.isLoading,
    required this.totalScore,
    required this.stats,
  });

  factory ProfileState.initial() {
    return ProfileState(
      isLoading: true,
      totalScore: 0,
      stats: ProfileStatsEntity.empty(),
    );
  }

  ProfileState copyWith({
    bool? isLoading,
    int? totalScore,
    ProfileStatsEntity? stats,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      totalScore: totalScore ?? this.totalScore,
      stats: stats ?? this.stats,
    );
  }
}