import 'package:twisted_files/features/auth/domain/entities/user_profile_entity.dart';
import 'package:twisted_files/features/auth/domain/repositories/auth_repository.dart';

class SignInAnonymouslyUseCase {
  final AuthRepository _repository;
  const SignInAnonymouslyUseCase(this._repository);

  Future<UserProfileEntity> call() => _repository.signInAnonymously();
}
