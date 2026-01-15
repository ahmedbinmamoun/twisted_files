import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';
import 'package:twisted_files/domain/use_cases/get_profile_stats_use_case.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ScoreRepository scoreRepository;
  final GetProfileStatsUseCase getCaseStats;

  ProfileCubit({
    required this.scoreRepository,
    required this.getCaseStats,
  }) : super(ProfileState.initial()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true));

    final score = await scoreRepository.getScore();
    final stats = await getCaseStats();

    emit(
      state.copyWith(
        isLoading: false,
        totalScore: score.totalScore,
        stats: stats,
      ),
    );
  }
}