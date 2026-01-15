import 'package:twisted_files/domain/entities/case_difficulty_entity.dart';

class CaseUnlockRoleEntity {
  final int requiredScore;

 const CaseUnlockRoleEntity({required this.requiredScore});

 factory CaseUnlockRoleEntity.free(){
  return const CaseUnlockRoleEntity(requiredScore: 0);
 }
}



CaseUnlockRoleEntity unlockRuleForDifficulty(
  CaseDifficultyEntity difficulty,
  int caseIndex
){
  switch (difficulty) {
    case CaseDifficultyEntity.easy:
    return CaseUnlockRoleEntity(requiredScore : caseIndex == 0 ? 0 : 30);
    case CaseDifficultyEntity.medium:
    return CaseUnlockRoleEntity(requiredScore : caseIndex == 0 ? 0 : 50);
    case CaseDifficultyEntity.hard:
    return CaseUnlockRoleEntity(requiredScore : caseIndex == 0 ? 0 : 60);
      
  }
}