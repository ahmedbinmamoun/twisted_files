class ProfileStatsEntity {
  final int easySolved;
  final int mediumSolved;
  final int hardSolved;

  const ProfileStatsEntity({
    required this.easySolved,
    required this.mediumSolved,
    required this.hardSolved,
  });

  factory ProfileStatsEntity.empty() =>
      const ProfileStatsEntity(easySolved: 0, mediumSolved: 0, hardSolved: 0);
}
