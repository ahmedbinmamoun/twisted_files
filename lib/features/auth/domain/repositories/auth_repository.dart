import 'package:twisted_files/features/auth/domain/entities/user_profile_entity.dart';

abstract class AuthRepository {
  Future<UserProfileEntity?> getCurrentProfile();
  Future<UserProfileEntity>  signInAnonymously();
  Future<UserProfileEntity>  signInWithGoogle();
  Future<void>               updateNickname(String nickname);
  Future<void>               signOut();
  Stream<UserProfileEntity?> get authStateChanges;

  /// Returns true if nickname is available (not taken by anyone else).
  Future<bool> isNicknameUnique(String nickname);
}
