import 'package:twisted_files/features/auth/domain/repositories/auth_repository.dart';

/// Result returned by the use case so the UI knows what happened.
enum NicknameUpdateResult { success, taken, tooShort, unchanged }

class UpdateNicknameUseCase {
  final AuthRepository _repository;
  const UpdateNicknameUseCase(this._repository);

  Future<NicknameUpdateResult> call(String nickname) async {
    final trimmed = nickname.trim();

    if (trimmed.length < 3)  return NicknameUpdateResult.tooShort;

    final unique = await _repository.isNicknameUnique(trimmed);
    if (!unique)             return NicknameUpdateResult.taken;

    await _repository.updateNickname(trimmed);
    return NicknameUpdateResult.success;
  }
}
