import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:twisted_files/core/services/supabase_service.dart';
import 'package:twisted_files/features/cases_list_screen/data/models/case_model.dart';

class CaseRemoteDataSource {
  final SupabaseClient _client;

  CaseRemoteDataSource({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  // ✅ يستخدم عمود id الأصلي في الجدول (مش JSON filter)
  Future<CaseModel> loadCase(String caseId) async {
    final res = await _client
        .from('cases')
        .select('data')
        .eq('id', caseId)
        .single();
    return CaseModel.fromJson(Map<String, dynamic>.from(res['data'] as Map));
  }

  // ✅ يفلتر من داخل الـ JSON لأن عمود difficulty في الجدول = null
  Future<List<CaseModel>> loadCasesByDifficulty(String difficulty) async {
    final res = await _client
        .from('cases')
        .select('data')
        .filter('data->>difficulty', 'eq', difficulty);
    return (res as List)
        .map((e) => CaseModel.fromJson(Map<String, dynamic>.from(e['data'] as Map)))
        .toList();
  }

  Future<List<CaseModel>> loadAllCases() async {
    final res = await _client.from('cases').select('data');
    return (res as List)
        .map((e) => CaseModel.fromJson(Map<String, dynamic>.from(e['data'] as Map)))
        .toList();
  }
}
