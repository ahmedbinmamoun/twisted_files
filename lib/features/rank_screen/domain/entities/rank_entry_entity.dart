class RankEntryEntity {
  final int    rank;
  final String userId;
  final String nickname;
  final int    totalScore;
  final bool   isCurrentUser;

  const RankEntryEntity({
    required this.rank,
    required this.userId,
    required this.nickname,
    required this.totalScore,
    required this.isCurrentUser,
  });
}
