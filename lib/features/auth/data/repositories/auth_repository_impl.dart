import 'package:twisted_files/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:twisted_files/features/auth/domain/entities/user_profile_entity.dart';
import 'package:twisted_files/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  const AuthRepositoryImpl(this._dataSource);

  UserProfileEntity _map(Map<String, dynamic> d) => UserProfileEntity(
    id:          d['id'],
    nickname:    d['nickname'] ?? 'Detective',
    isAnonymous: d['is_anonymous'] ?? true,
    avatarUrl:   d['avatar_url'],
  );

  @override Future<UserProfileEntity?> getCurrentProfile() async {
    final data = await _dataSource.getCurrentProfile();
    return data == null ? null : _map(data);
  }

  @override Future<UserProfileEntity> signInAnonymously() async =>
      _map(await _dataSource.signInAnonymously());

  @override Future<UserProfileEntity> signInWithGoogle() async =>
      _map(await _dataSource.signInWithGoogle());

  @override Future<void> updateNickname(String nickname) async {
    final profile = await getCurrentProfile();
    if (profile == null) return;
    await _dataSource.updateNickname(profile.id, nickname);
  }

  @override Future<void> signOut() => _dataSource.signOut();

  @override Stream<UserProfileEntity?> get authStateChanges =>
      _dataSource.authStateStream.map((d) => d == null ? null : _map(d));

  @override Future<bool> isNicknameUnique(String nickname) async {
    final profile = await getCurrentProfile();
    if (profile == null) return true;
    return _dataSource.isNicknameUnique(nickname, profile.id);
  }
}
