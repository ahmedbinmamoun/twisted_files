import 'package:twisted_files/features/score/domain/entities/score_entity.dart';

class ScoreModel {
  final int totalScore;
  final int questionPoints;
  final int suspectPoints;

  const ScoreModel({
    required this.totalScore,
    required this.questionPoints,
    required this.suspectPoints,
  });

  factory ScoreModel.fromJson(Map<String, dynamic> json) => ScoreModel(
    totalScore: json['totalScore'] ?? 0,
    questionPoints: json['questionPoints'] ?? 0,
    suspectPoints: json['suspectPoints'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'totalScore': totalScore,
    'questionPoints': questionPoints,
    'suspectPoints': suspectPoints,
  };

  ScoreEntity toEntity() => ScoreEntity(
    totalScore: totalScore,
    questionPoints: questionPoints,
    suspectPoints: suspectPoints,
  );

  factory ScoreModel.fromEntity(ScoreEntity e) => ScoreModel(
    totalScore: e.totalScore,
    questionPoints: e.questionPoints,
    suspectPoints: e.suspectPoints,
  );
}
