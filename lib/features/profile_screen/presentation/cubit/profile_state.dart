import 'package:twisted_files/features/profile_screen/domain/entities/profile_stats_entity.dart';

/// حالات تحديث الـ nickname
enum NicknameStatus { idle, loading, success, taken, tooShort }

class ProfileState {
  final bool            isLoading;
  final int             totalScore;
  final int             userRank;
  final ProfileStatsEntity stats;

  // ── Nickname update state ─────────────────────────────────────────────────
  final NicknameStatus  nicknameStatus;
  final String          nicknameError;

  const ProfileState({
    required this.isLoading,
    required this.totalScore,
    required this.userRank,
    required this.stats,
    this.nicknameStatus = NicknameStatus.idle,
    this.nicknameError  = '',
  });

  factory ProfileState.initial() => ProfileState(
    isLoading:  true,
    totalScore: 0,
    userRank:   0,
    stats:      ProfileStatsEntity.empty(),
  );

  ProfileState copyWith({
    bool?             isLoading,
    int?              totalScore,
    int?              userRank,
    ProfileStatsEntity? stats,
    NicknameStatus?   nicknameStatus,
    String?           nicknameError,
  }) => ProfileState(
    isLoading:      isLoading      ?? this.isLoading,
    totalScore:     totalScore     ?? this.totalScore,
    userRank:       userRank       ?? this.userRank,
    stats:          stats          ?? this.stats,
    nicknameStatus: nicknameStatus ?? this.nicknameStatus,
    nicknameError:  nicknameError  ?? this.nicknameError,
  );
}
