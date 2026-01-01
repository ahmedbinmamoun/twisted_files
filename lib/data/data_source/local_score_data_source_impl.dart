import 'package:shared_preferences/shared_preferences.dart';
import 'package:twisted_files/data/data_source/local_score_data_source.dart';

class LocalScoreDataSourceImpl implements LocalScoreDataSource {
  final SharedPreferences prefs;
  LocalScoreDataSourceImpl(this.prefs);
  static const _scoreKey = 'total_score';

  @override
  Future<int> getScore() async {
    final value = await prefs.getInt(_scoreKey) ?? 0;
    print('DEBUG: LocalScoreDataSourceImpl.getScore -> $value');
    return value;
  }

  @override
  Future<void> saveScore(int score) async {
    await prefs.setInt(_scoreKey, score);
    final saved = await prefs.getInt(_scoreKey);
     print('DEBUG: LocalScoreDataSourceImpl.saveScore saved=$saved');
  }

}