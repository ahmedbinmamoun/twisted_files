import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assets.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/di/injection_container.dart';
import 'package:twisted_files/core/services/rewarded_ad_service.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/question_entity.dart';
import 'package:twisted_files/features/common/animations/shake_animation.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/questions_screen/presentation/cubit/questions_cubit.dart';
import 'package:twisted_files/features/score/presentation/score_view_model.dart';
import 'package:twisted_files/features/score/presentation/score_widget.dart';

class QuestionContentWidget extends StatefulWidget {
  final int            questionIndex;
  final int            total;
  final QuestionEntity question;
  final CaseEntity     caseEntity;

  const QuestionContentWidget({
    super.key,
    required this.questionIndex,
    required this.total,
    required this.question,
    required this.caseEntity,
  });

  @override
  State<QuestionContentWidget> createState() => _QuestionContentWidgetState();
}

class _QuestionContentWidgetState extends State<QuestionContentWidget> {
  // ── Answer state ─────────────────────────────────────────────────────────────
  String? _selectedOption;
  bool    _selectedIsCorrect = false;
  bool    _disabled          = false;
  bool    _shake             = false;

  // ── Hint state ───────────────────────────────────────────────────────────────
  bool _showHint  = false;
  bool _adLoading = false;

  /// عداد static يتراكم عبر كل أسئلة القضية الواحدة
  static int       _hintUsedCount = 0;
  static const int _freeHints     = 3;

  /// استدعيها من InvestigationQuestionsScreen عند بدء قضية جديدة
  static void resetHintCount() => _hintUsedCount = 0;

  // ── Audio ─────────────────────────────────────────────────────────────────────
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void didUpdateWidget(covariant QuestionContentWidget old) {
    super.didUpdateWidget(old);
    if (old.questionIndex != widget.questionIndex) {
      setState(() => _showHint = false);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // ── Hint logic ────────────────────────────────────────────────────────────────

  void _onHintTap() {
    // toggle
    if (_showHint) {
      setState(() => _showHint = false);
      return;
    }

    // أول 3 مجانية
    if (_hintUsedCount < _freeHints) {
      _hintUsedCount++;
      setState(() => _showHint = true);
      return;
    }

    // بعد الـ 3 — يشوف ad
    setState(() => _adLoading = true);

    getIt<RewardedAdService>().showAd(
      onRewarded: () {
        if (mounted) setState(() { _showHint = true; _adLoading = false; });
      },
      onNotReady: () {
        // ad مش جاهزة — امنح الـ hint مجاناً
        if (mounted) setState(() { _showHint = true; _adLoading = false; });
      },
    );
  }

  // ── Audio ─────────────────────────────────────────────────────────────────────

  Future<void> _playSound(bool correct) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.play(
        AssetSource(correct ? AppAssets.correctSound : AppAssets.wrongSound),
      );
    } catch (e) {
      debugPrint('Sound error: $e');
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final scoreVm  = getIt<ScoreViewModel>();
    final hint     = widget.question.hint;
    final freeLeft = (_freeHints - _hintUsedCount).clamp(0, _freeHints);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Header ───────────────────────────────────────────────────────────
        Row(
          children: [
            
            
            if (hint != null && hint.isNotEmpty)
              _HintButton(
                freeLeft:  freeLeft,
                isLoading: _adLoading,
                isShowing: _showHint,
                onTap:     _onHintTap,
              ),
            const Spacer(),
            const ScoreWidget(),
          ],
        ),

        // ── Hint card ─────────────────────────────────────────────────────────
        if (_showHint && hint != null)
          _HintCard(hint: hint),

        SizedBox(height: 50.h),
        Text(widget.question.question, style: AppStyles.largeTitle),
        SizedBox(height: 40.h),

        // ── Options ───────────────────────────────────────────────────────────
        ...widget.question.options.map((option) {
          final isSelected  = _selectedOption == option;
          final borderColor = isSelected
              ? (_selectedIsCorrect ? AppColors.greenColor : AppColors.redColor)
              : null;

          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: ShakeAnimation(
              shake: _shake && isSelected && !_selectedIsCorrect,
              child: PrimaryButton(
                text:        option,
                borderColor: borderColor,
                onPressed: () async {
                  if (_disabled) return;
                  final isCorrect = option == widget.question.correctAnswer;
                  setState(() {
                    _selectedOption    = option;
                    _selectedIsCorrect = isCorrect;
                    _disabled          = true;
                    if (!isCorrect) _shake = true;
                  });
                  await _playSound(isCorrect);
                  await scoreVm.answerQuestion(widget.caseEntity, isCorrect);
                  await Future.delayed(const Duration(milliseconds: 600));
                  setState(() {
                    _selectedOption    = null;
                    _selectedIsCorrect = false;
                    _disabled          = false;
                    _shake             = false;
                  });
                  context.read<QuestionsCubit>().next();
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ── Hint Button ───────────────────────────────────────────────────────────────
class _HintButton extends StatelessWidget {
  final int          freeLeft;
  final bool         isLoading;
  final bool         isShowing;
  final VoidCallback onTap;

  const _HintButton({
    required this.freeLeft,
    required this.isLoading,
    required this.isShowing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isShowing
              ? AppColors.primaryColor.withOpacity(0.15)
              : AppColors.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(isShowing ? 0.7 : 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                width: 12.w, height: 12.w,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: AppColors.primaryColor,
                ),
              )
            else
              Icon(Icons.lightbulb_outline,
                size: 16.sp, color: AppColors.primaryColor),
            SizedBox(width: 4.w),
            Text(
              freeLeft > 0 ? 'Hint ' : 'Hint ',
              style: AppStyles.mediumBody.copyWith(fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hint Card ─────────────────────────────────────────────────────────────────
class _HintCard extends StatelessWidget {
  final String hint;
  const _HintCard({required this.hint});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin:   EdgeInsets.only(top: 12.h, bottom: 4.h),
      padding:  EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color:        const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12.r),
        border:       Border.all(color: const Color(0xFFFFE082), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb, color: const Color(0xFFFFA000), size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              hint,
              style: AppStyles.mediumBody.copyWith(
                color: const Color(0xFF5D4037),
                fontSize: 12.sp,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
