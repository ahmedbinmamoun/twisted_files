import 'package:flutter/material.dart';

class CaseResultEntity {
  final String caseNumber;
  final String caseTitle;
  final bool isSuccess;

  final int solvedQuestions;
  final int totalQuestions;
  final int questionPoints;
  final int suspectBonus;
  final int totalScore;
  final int rank;

  final String returnRoute; 

  CaseResultEntity({
    required this.caseNumber,
    required this.caseTitle,
    required this.isSuccess,
    required this.solvedQuestions,
    required this.totalQuestions,
    required this.questionPoints,
    required this.suspectBonus,
    required this.totalScore,
    required this.rank,
    required this.returnRoute,
  });
}