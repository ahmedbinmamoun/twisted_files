import 'dart:math';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:twisted_files/core/services/supabase_service.dart';

class AuthRemoteDataSource {
  final SupabaseClient _client;
  final GoogleSignIn   _googleSignIn;

  AuthRemoteDataSource({SupabaseClient? client, GoogleSignIn? googleSignIn})
      : _client      = client      ?? SupabaseService.client,
        _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: ['email', 'profile']);

  // ─── Helpers ─────────────────────────────────────────────────────────────

  String _generateNickname() {
    const adj   = ['Sharp', 'Silent', 'Clever', 'Bold', 'Keen', 'Swift', 'Sly', 'Dark'];
    const nouns = ['Detective', 'Agent', 'Sleuth', 'Scout', 'Hawk', 'Fox', 'Wolf'];
    final r = Random();
    return '${adj[r.nextInt(adj.length)]} ${nouns[r.nextInt(nouns.length)]}';
  }

  // ─── Nickname uniqueness ─────────────────────────────────────────────────

  /// Returns true if the nickname is NOT already taken by another user.
  Future<bool> isNicknameUnique(String nickname, String currentUserId) async {
    final res = await _client
        .from('profiles')
        .select('id')
        .ilike('nickname', nickname)   // case-insensitive check
        .neq('id', currentUserId)      // exclude self
        .limit(1);
    return (res as List).isEmpty;
  }

  // ─── Auth ─────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getCurrentProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;
    return await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
  }

  Future<Map<String, dynamic>> signInAnonymously() async {
    final res      = await _client.auth.signInAnonymously();
    final user     = res.user!;
    final nickname = _generateNickname();
    await _client.from('profiles').upsert({
      'id':           user.id,
      'nickname':     nickname,
      'is_anonymous': true,
    });
    return {'id': user.id, 'nickname': nickname, 'is_anonymous': true};
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');

    final googleAuth  = await googleUser.authentication;
    final idToken     = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;
    if (idToken == null) throw Exception('No ID token from Google');

    final res  = await _client.auth.signInWithIdToken(
      provider:    OAuthProvider.google,
      idToken:     idToken,
      accessToken: accessToken,
    );
    final user     = res.user!;
    final existing = await _client.from('profiles').select().eq('id', user.id).maybeSingle();

    if (existing == null) {
      final nickname = googleUser.displayName ?? _generateNickname();
      await _client.from('profiles').insert({
        'id':           user.id,
        'nickname':     nickname,
        'is_anonymous': false,
        'avatar_url':   googleUser.photoUrl,
      });
      return {'id': user.id, 'nickname': nickname, 'is_anonymous': false, 'avatar_url': googleUser.photoUrl};
    } else {
      await _client.from('profiles').update({
        'is_anonymous': false,
        if (googleUser.photoUrl != null) 'avatar_url': googleUser.photoUrl,
      }).eq('id', user.id);
      return {...existing, 'is_anonymous': false};
    }
  }

  Future<void> updateNickname(String userId, String nickname) async {
    await _client.from('profiles').update({'nickname': nickname}).eq('id', userId);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _client.auth.signOut();
  }

  Stream<Map<String, dynamic>?> get authStateStream =>
      _client.auth.onAuthStateChange.asyncMap((event) async {
        if (event.session == null) return null;
        return await getCurrentProfile();
      });
}
