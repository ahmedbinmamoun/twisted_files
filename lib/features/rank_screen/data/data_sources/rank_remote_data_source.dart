import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:twisted_files/core/services/supabase_service.dart';

class RankRemoteDataSource {
  final SupabaseClient _client;

  RankRemoteDataSource({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  String? get _userId => _client.auth.currentUser?.id;

  /// All players ordered by score desc (for leaderboard screen).
  Future<List<Map<String, dynamic>>> fetchLeaderboard() async {
    final res = await _client
        .from('user_scores')
        .select('user_id, total_score, profiles(nickname)')
        .order('total_score', ascending: false)
        .limit(100);
    return (res as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// Count how many players have a HIGHER score → that + 1 = current user rank.
  Future<int> fetchUserRank() async {
  final uid = _userId;
  if (uid == null) return 0;

  // Get current user score
  final myScoreRes = await _client
      .from('user_scores')
      .select('total_score')
      .eq('user_id', uid)
      .maybeSingle();

  if (myScoreRes == null) return 0;

  final myScore = (myScoreRes['total_score'] as num?)?.toInt() ?? 0;

  // Fetch all users with higher score and count them
  final countRes = await _client
      .from('user_scores')
      .select('user_id')
      .gt('total_score', myScore);

  final higherCount = (countRes as List).length;
  return higherCount + 1;
}

  String? get currentUserId => _userId;
}
