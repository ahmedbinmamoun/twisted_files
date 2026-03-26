class ScoreEntity {
  final int totalScore;
  final int questionPoints;
  final int suspectPoints;

  ScoreEntity({
    required this.totalScore,
    required this.questionPoints,
    required this.suspectPoints,
  });

  ScoreEntity copyWith({int? totalScore, int? questionPoints, int? suspectPoints}) {
    return ScoreEntity(
      totalScore: totalScore ?? this.totalScore,
      questionPoints: questionPoints ?? this.questionPoints,
      suspectPoints: suspectPoints ?? this.suspectPoints,
    );
  }

  Map<String, dynamic> toMap() => {
    'totalScore': totalScore,
    'questionPoints': questionPoints,
    'suspectPoints': suspectPoints,
  };

  factory ScoreEntity.fromMap(Map<String, dynamic> map) => ScoreEntity(
    totalScore: map['totalScore'] ?? 0,
    questionPoints: map['questionPoints'] ?? 0,
    suspectPoints: map['suspectPoints'] ?? 0,
  );
}
