import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:twisted_files/features/auth/domain/entities/user_profile_entity.dart';
import 'package:twisted_files/features/auth/domain/use_cases/get_current_profile_use_case.dart';
import 'package:twisted_files/features/auth/domain/use_cases/sign_in_anonymously_use_case.dart';
import 'package:twisted_files/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';
import 'package:twisted_files/features/auth/domain/use_cases/update_nickname_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetCurrentProfileUseCase  _getProfile;
  final SignInAnonymouslyUseCase  _signInAnon;
  final SignInWithGoogleUseCase   _signInGoogle;
  final UpdateNicknameUseCase     _updateNickname;

  AuthCubit({
    required GetCurrentProfileUseCase  getProfile,
    required SignInAnonymouslyUseCase  signInAnon,
    required SignInWithGoogleUseCase   signInGoogle,
    required UpdateNicknameUseCase     updateNickname,
  })  : _getProfile      = getProfile,
        _signInAnon      = signInAnon,
        _signInGoogle    = signInGoogle,
        _updateNickname  = updateNickname,
        super(AuthInitial());

  Future<void> initSession() async {
    emit(AuthLoading());

    // ── Try Supabase auth with retries ───────────────────────────────────
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        var profile = await _getProfile();
        if (profile == null) {
          print('🔄 signing in anonymously... attempt $attempt');
          profile = await _signInAnon();
        }
        print('✅ session ready: ${profile.id}');
        emit(AuthSignedIn(profile));
        return;
      } catch (e) {
        print('❌ initSession attempt $attempt: $e');
        if (attempt < 3) {
          await Future.delayed(Duration(seconds: attempt * 2));
        }
      }
    }

    // ── Supabase auth failed — use local offline profile ─────────────────
    print('⚠️ Using offline profile (no Supabase session)');
    final offlineProfile = await _getOrCreateOfflineProfile();
    emit(AuthSignedIn(offlineProfile));
  }

  /// Creates a local UUID-based profile stored in SharedPreferences.
  /// Allows the app to work fully offline for score/progress.
  Future<UserProfileEntity> _getOrCreateOfflineProfile() async {
    final prefs    = await SharedPreferences.getInstance();
    var   uid      = prefs.getString('offline_uid');
    var   nickname = prefs.getString('offline_nickname');

    if (uid == null) {
      uid      = const Uuid().v4();
      nickname = _randomNickname();
      await prefs.setString('offline_uid',      uid);
      await prefs.setString('offline_nickname', nickname);
    }

    return UserProfileEntity(
      id:          uid,
      nickname:    nickname ?? 'Detective',
      isAnonymous: true,
      avatarUrl:   null,
    );
  }

  String _randomNickname() {
  const adjectives = [
    'Sharp', 'Silent', 'Clever', 'Bold', 'Dark',
    'Swift', 'Sly', 'Keen', 'Iron', 'Ghost',
    'Blind', 'Cold', 'Lone', 'Steel', 'Shadow',
    'Crimson', 'Phantom', 'Silver', 'Hollow', 'Ancient',
  ];

  const nouns = [
    'Detective', 'Agent', 'Sleuth', 'Scout', 'Fox',
    'Wolf', 'Hawk', 'Raven', 'Viper', 'Hunter',
    'Cipher', 'Watcher', 'Blade', 'Tracker', 'Phantom',
    'Hound', 'Falcon', 'Dagger', 'Specter', 'Lynx',
  ];

  final r = Random();
  final adj  = adjectives[r.nextInt(adjectives.length)];
  final noun = nouns[r.nextInt(nouns.length)];

  final num  = r.nextInt(999) + 1;

  return '$adj $noun #$num';
}

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final profile = await _signInGoogle();
      emit(AuthSignedIn(profile));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> updateNickname(String nickname) async {
    try {
      await _updateNickname(nickname);
      final current = state;
      if (current is AuthSignedIn) {
        emit(AuthSignedIn(current.profile.copyWith(nickname: nickname)));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}