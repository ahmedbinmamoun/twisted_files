class ProfileStatsEntity {
  final int easySolved;
  final int mediumSolved;
  final int hardSolved;

  ProfileStatsEntity({
    required this.easySolved,
    required this.mediumSolved,
    required this.hardSolved
  });

  factory ProfileStatsEntity.empty(){
    return ProfileStatsEntity(
      easySolved: 0,
       mediumSolved: 0,
        hardSolved: 0,
        );
  }
}