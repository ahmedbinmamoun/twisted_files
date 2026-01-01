enum CaseDifficultyEntity {
  easy,
  medium,
  hard,
}


CaseDifficultyEntity difficultyFromString(String value){

  switch (value.toLowerCase()){
    case 'easy' : return CaseDifficultyEntity.easy;
    case 'medium' : return CaseDifficultyEntity.medium;
    case 'hsrd' : return CaseDifficultyEntity.hard;
    default : return CaseDifficultyEntity.easy;
  }
}


int difficultyMultiplier(CaseDifficultyEntity difficulty){
  switch (difficulty) {
    case CaseDifficultyEntity.easy: return 1;
    case CaseDifficultyEntity.medium: return 2;
    case CaseDifficultyEntity.hard: return 3;
      
    default: return 1;
  }
}