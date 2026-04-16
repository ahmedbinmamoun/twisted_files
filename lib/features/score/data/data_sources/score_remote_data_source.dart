import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:twisted_files/core/services/supabase_service.dart';
import 'package:twisted_files/features/cases_list_screen/data/models/case_progress_model.dart';

class ScoreRemoteDataSource {
  final SupabaseClient _client;

  ScoreRemoteDataSource({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  // ✅ null-safe — يرجع null لو مفيش user
  String? get _userId => _client.auth.currentUser?.id;

  Future<int> getScore() async {
    final uid = _userId;
    if (uid == null) return 0; // ← مفيش user = score صفر

    final res = await _client
        .from('user_scores')
        .select('total_score')
        .eq('user_id', uid)
        .maybeSingle();
    return (res?['total_score'] as int?) ?? 0;
  }

  Future<void> saveScore(int score) async {
  // انتظر لحد ما يكون فيه user session
  String? uid = _userId;
  if (uid == null) {
    await Future.delayed(const Duration(seconds: 2));
    uid = _userId;
  }
  if (uid == null) {
    print('❌ saveScore: no user session');
    return;
  }

  await _client.from('user_scores').upsert({
    'user_id':     uid,
    'total_score': score,
  });
}

  Future<void> saveCaseProgress(CaseProgressModel model) async {
    final uid = _userId;
    if (uid == null) return;

    await _client.from('case_progress').upsert({
      'user_id':    uid,
      'case_id':    model.caseId,
      'completed':  model.completed,
      'case_score': model.caseScore,
      'difficulty': model.toJson()['difficulty'],
    });
  }

  Future<List<CaseProgressModel>> getAllCompletedCases() async {
    final uid = _userId;
    if (uid == null) return []; // ← مفيش user = list فاضية

    final res = await _client
        .from('case_progress')
        .select()
        .eq('user_id', uid)
        .eq('completed', true);

    return (res as List)
        .map((e) => CaseProgressModel.fromJson(_remapKeys(e)))
        .toList();
  }

  Future<void> resetCase(String caseId) async {
    final uid = _userId;
    if (uid == null) return;

    await _client
        .from('case_progress')
        .delete()
        .eq('user_id', uid)
        .eq('case_id', caseId);
  }

  Map<String, dynamic> _remapKeys(Map<String, dynamic> m) => {
    'caseId':     m['case_id'],
    'completed':  m['completed'],
    'caseScore':  m['case_score'],
    'difficulty': m['difficulty'],
  };
}