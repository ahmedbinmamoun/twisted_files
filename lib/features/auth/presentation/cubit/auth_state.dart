import 'package:twisted_files/features/auth/domain/entities/user_profile_entity.dart';

abstract class AuthState {}

class AuthInitial   extends AuthState {}
class AuthLoading   extends AuthState {}
class AuthSignedIn  extends AuthState {
  final UserProfileEntity profile;
  AuthSignedIn(this.profile);
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
