import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/features/profile_screen/domain/use_cases/get_profile_stats_use_case.dart';
import 'package:twisted_files/features/rank_screen/domain/use_cases/get_user_rank_use_case.dart';
import 'package:twisted_files/features/score/domain/repositories/score_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ScoreRepository       _scoreRepository;
  final GetProfileStatsUseCase _getStats;
  final GetUserRankUseCase     _getUserRank;

  ProfileCubit({
    required ScoreRepository       scoreRepository,
    required GetProfileStatsUseCase getStats,
    required GetUserRankUseCase     getUserRank,
  })  : _scoreRepository = scoreRepository,
        _getStats        = getStats,
        _getUserRank     = getUserRank,
        super(ProfileState.initial()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true));
    try {
      // Run all 3 fetches in parallel for speed
      final results = await Future.wait([
        _scoreRepository.getScore(),
        _getStats(),
        _getUserRank(),
      ]);

      emit(state.copyWith(
        isLoading:  false,
        totalScore: (results[0] as dynamic).totalScore as int,
        stats:      results[1] as dynamic,
        userRank:   results[2] as int,
      ));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
