import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/features/auth/domain/use_cases/update_nickname_use_case.dart';
import 'package:twisted_files/features/profile_screen/domain/use_cases/get_profile_stats_use_case.dart';
import 'package:twisted_files/features/rank_screen/domain/use_cases/get_user_rank_use_case.dart';
import 'package:twisted_files/features/score/domain/repositories/score_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ScoreRepository        _scoreRepository;
  final GetProfileStatsUseCase _getStats;
  final GetUserRankUseCase     _getUserRank;
  final UpdateNicknameUseCase  _updateNickname;

  ProfileCubit({
    required ScoreRepository        scoreRepository,
    required GetProfileStatsUseCase getStats,
    required GetUserRankUseCase     getUserRank,
    required UpdateNicknameUseCase  updateNickname,
  })  : _scoreRepository = scoreRepository,
        _getStats        = getStats,
        _getUserRank     = getUserRank,
        _updateNickname  = updateNickname,
        super(ProfileState.initial());

  // ── Load profile data ────────────────────────────────────────────────────

  Future<void> loadProfile() async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true));
    try {
      final results = await Future.wait([
        _scoreRepository.getScore(),
        _getStats(),
        _getUserRank(),
      ]);

      if (isClosed) return;
      emit(state.copyWith(
        isLoading:  false,
        totalScore: (results[0] as dynamic).totalScore as int,
        stats:      results[1] as dynamic,
        userRank:   results[2] as int,
      ));
    } catch (_) {
      if (!isClosed) emit(state.copyWith(isLoading: false));
    }
  }

  // ── Nickname update ───────────────────────────────────────────────────────

  Future<void> saveNickname(String name) async {
    final trimmed = name.trim();

    if (trimmed.length < 3) {
      emit(state.copyWith(
        nicknameStatus: NicknameStatus.tooShort,
        nicknameError:  'Minimum 3 characters',
      ));
      return;
    }

    emit(state.copyWith(
      nicknameStatus: NicknameStatus.loading,
      nicknameError:  '',
    ));

    final result = await _updateNickname(trimmed);

    if (isClosed) return;

    switch (result) {
      case NicknameUpdateResult.success:
        emit(state.copyWith(nicknameStatus: NicknameStatus.success));
        break;
      case NicknameUpdateResult.taken:
        emit(state.copyWith(
          nicknameStatus: NicknameStatus.taken,
          nicknameError:  'Name already taken, try another',
        ));
        break;
      case NicknameUpdateResult.tooShort:
        emit(state.copyWith(
          nicknameStatus: NicknameStatus.tooShort,
          nicknameError:  'Minimum 3 characters',
        ));
        break;
      case NicknameUpdateResult.unchanged:
        emit(state.copyWith(nicknameStatus: NicknameStatus.success));
        break;
    }
  }

  void resetNicknameStatus() {
    if (!isClosed) {
      emit(state.copyWith(
        nicknameStatus: NicknameStatus.idle,
        nicknameError:  '',
      ));
    }
  }
}
