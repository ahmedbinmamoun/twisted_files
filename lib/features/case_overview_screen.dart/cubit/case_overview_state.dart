import 'package:twisted_files/domain/entities/case_entity.dart';

class CaseOverviewState {
  final bool isLoading;
  final CaseEntity? caseEntity;
  final bool isCompleted;
  final int previousScore;
  final String? error;

  const CaseOverviewState({
    required this.isLoading,
    this.caseEntity,
    this.isCompleted = false,
    this.previousScore = 0,
    this.error,
  });

  factory CaseOverviewState.initial() {
    return const CaseOverviewState(isLoading: true);
  }

  CaseOverviewState copyWith({
    bool? isLoading,
    CaseEntity? caseEntity,
    bool? isCompleted,
    int? previousScore,
    String? error,
  }) {
    return CaseOverviewState(
      isLoading: isLoading ?? this.isLoading,
      caseEntity: caseEntity ?? this.caseEntity,
      isCompleted: isCompleted ?? this.isCompleted,
      previousScore: previousScore ?? this.previousScore,
      error: error,
    );
  }
}