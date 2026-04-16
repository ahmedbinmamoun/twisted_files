import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/features/rank_screen/domain/use_cases/get_leaderboard_use_case.dart';
import 'rank_state.dart';

class RankCubit extends Cubit<RankState> {
  final GetLeaderboardUseCase _getLeaderboard;

  RankCubit({required GetLeaderboardUseCase getLeaderboard})
      : _getLeaderboard = getLeaderboard,
        super(RankLoading());

  Future<void> load() async {
  if (isClosed) return; // ← أضف في الأول
  emit(RankLoading());
  try {
    final entries = await _getLeaderboard();
    if (isClosed) return; // ← أضف قبل emit
    final myEntry = entries.where((e) => e.isCurrentUser).firstOrNull;
    emit(RankLoaded(entries: entries, currentUserEntry: myEntry));
  } catch (e) {
    if (isClosed) return; // ← أضف
    emit(RankError(e.toString()));
  }
}
}
