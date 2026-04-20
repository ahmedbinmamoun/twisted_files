import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:twisted_files/core/services/supabase_service.dart';
import 'package:twisted_files/features/cases_list_screen/data/models/case_model.dart';
 

class CaseRemoteDataSource {
  final SupabaseClient _client;
 
  CaseRemoteDataSource({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;
 
  // ── In-memory cache ───────────────────────────────────────────────────────
  final Map<String, CaseModel>       _caseCache       = {};
  final Map<String, List<CaseModel>> _difficultyCache = {};
 
  // ── Public API ────────────────────────────────────────────────────────────
 
  Future<CaseModel> loadCase(String caseId) async {
    if (_caseCache.containsKey(caseId)) {
      if (kDebugMode) print('📦 cache hit: case $caseId');
      return _caseCache[caseId]!;
    }
 
    if (kDebugMode) print('🌐 fetching case $caseId from Supabase');
    final res = await _client
        .from('cases')
        .select('data')
        .eq('id', caseId)
        .single();
 
    final model = CaseModel.fromJson(
      Map<String, dynamic>.from(res['data'] as Map),
    );
 
    _caseCache[caseId] = model; 
    return model;
  }
 
  
Future<List<CaseModel>> loadCasesByDifficulty(
  String difficulty, {
  int page     = 0,
  int pageSize = 10,
}) async {
  final cacheKey = '${difficulty}_$page';

  if (_difficultyCache.containsKey(cacheKey)) {
    if (kDebugMode) print('📦 cache hit: $cacheKey');
    return _difficultyCache[cacheKey]!;
  }

  if (kDebugMode) print('🌐 fetching $cacheKey from Supabase');
  final from = page * pageSize;
  final to   = from + pageSize - 1;

  final res = await _client
      .from('cases')
      .select('data')
      .filter('data->>difficulty', 'eq', difficulty)
      .range(from, to);

  final models = (res as List)
      .map((e) => CaseModel.fromJson(
            Map<String, dynamic>.from(e['data'] as Map),
          ))
      .toList();

  _difficultyCache[cacheKey] = models; 

  for (final m in models) {
    _caseCache[m.id] = m;
  }

  return models;
}
  /// يجيب كل القضايا — من الـ cache لو اتحملوا كلهم قبل كده
  Future<List<CaseModel>> loadAllCases() async {
    if (kDebugMode) print('🌐 fetching all cases from Supabase');
    final res = await _client.from('cases').select('data');
 
    final models = (res as List)
        .map((e) => CaseModel.fromJson(
              Map<String, dynamic>.from(e['data'] as Map),
            ))
        .toList();
 
    // حدّث الـ caches
    for (final m in models) {
      _caseCache[m.id] = m;
    }
 
    return models;
  }
 
  /// امسح الـ cache — استدعيها لو المستخدم عمل pull-to-refresh
  void clearCache() {
    _caseCache.clear();
    _difficultyCache.clear();
    if (kDebugMode) print('🗑️ case cache cleared');
  }
 
  // ── Cache stats (للـ debug فقط) ──────────────────────────────────────────
  int get cachedCasesCount      => _caseCache.length;
  int get cachedDifficultiesCount => _difficultyCache.length;
}
 