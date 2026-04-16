import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_result_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/suspect_entity.dart';
import 'package:twisted_files/features/rank_screen/domain/use_cases/get_user_rank_use_case.dart';
import 'package:twisted_files/features/score/presentation/score_view_model.dart';
import 'choose_suspect_state.dart';

/// SRP: يدير فقط منطق اختيار المشتبه به وحساب النتيجة.
class ChooseSuspectCubit extends Cubit<ChooseSuspectState> {
  final ScoreViewModel _scoreVm;
  final CaseEntity     _caseEntity;
  final GetUserRankUseCase _getUserRank; 

  ChooseSuspectCubit({
    required ScoreViewModel scoreVm,
    required CaseEntity     caseEntity,
    required GetUserRankUseCase getUserRank,
  })  : _scoreVm    = scoreVm,
        _caseEntity = caseEntity,
        _getUserRank = getUserRank,
        super(const ChooseSuspectIdle());

  Future<void> selectSuspect(SuspectEntity suspect) async {
    if (state is ChooseSuspectLoading) return; // منع double-tap
    if (isClosed) return;

    emit(ChooseSuspectLoading(suspect));

    try {
      final isCorrect =
          suspect.id.trim() == _caseEntity.correctSuspectId.trim();

      // حساب نقاط المشتبه به
      await _scoreVm.solveSuspect(_caseEntity);

      // احفظ session stats قبل finalizeCase (بيعمل reset ليهم)
      final sessionSolved    = _scoreVm.sessionSolvedCount;
      final sessionQPts      = _scoreVm.sessionQuestionGross;
      final sessionPenalty   = _scoreVm.sessionPenalty;
      final sessionSuspect   = _scoreVm.sessionSuspectGross;

      // احفظ النتيجة في Supabase
      await _scoreVm.finalizeCase(_caseEntity);

      final rank = await _getUserRank();

      if (isClosed) return;

      emit(ChooseSuspectDone(
        isCorrect: isCorrect,
        result: CaseResultEntity(
          caseNumber:      _caseEntity.caseNumber,
          caseTitle:       _caseEntity.title,
          isSuccess:       isCorrect,
          solvedQuestions: sessionSolved,
          totalQuestions:  _caseEntity.questions.length,
          questionPoints:  sessionQPts,
          suspectBonus:    sessionSuspect,
          penalty:         sessionPenalty,
          totalScore:      _scoreVm.score.totalScore,
          rank:            rank,
        ),
      ));
    } catch (e, st) {
      if (kDebugMode) print('ChooseSuspectCubit error: $e\n$st');
      if (!isClosed) emit(ChooseSuspectError(e.toString()));
    }
  }

  void retryIdle() {
    if (!isClosed) emit(const ChooseSuspectIdle());
  }
}
