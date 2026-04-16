class CaseUnlockRoleEntity {
  final int requiredScore;
  const CaseUnlockRoleEntity({required this.requiredScore});
  factory CaseUnlockRoleEntity.free() => const CaseUnlockRoleEntity(requiredScore: 0);
}
