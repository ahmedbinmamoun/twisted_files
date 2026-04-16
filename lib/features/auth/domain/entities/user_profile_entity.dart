class UserProfileEntity {
  final String id;
  final String nickname;
  final bool isAnonymous;
  final String? avatarUrl;

  const UserProfileEntity({
    required this.id,
    required this.nickname,
    required this.isAnonymous,
    this.avatarUrl,
  });

  UserProfileEntity copyWith({
    String? nickname,
    bool? isAnonymous,
    String? avatarUrl,
  }) {
    return UserProfileEntity(
      id: id,
      nickname: nickname ?? this.nickname,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
