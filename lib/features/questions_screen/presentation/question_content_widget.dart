import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:twisted_files/core/constants/app_assets.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/di/injection_container.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/question_entity.dart';
import 'package:twisted_files/features/common/animations/shake_animation.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/questions_screen/presentation/cubit/questions_cubit.dart';
import 'package:twisted_files/features/score/presentation/score_view_model.dart';
import 'package:twisted_files/features/score/presentation/score_widget.dart';

class QuestionContentWidget extends StatefulWidget {
  final int questionIndex;
  final int total;
  final QuestionEntity question;
  final CaseEntity caseEntity;

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
  String? _selectedOption;
  bool    _selectedIsCorrect = false;
  bool    _disabled          = false;
  bool    _shake             = false;
  bool    _showHint          = false;
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _showHint    = false;
  }

  @override
  void didUpdateWidget(covariant QuestionContentWidget old) {
    super.didUpdateWidget(old);
    // Reset hint visibility when question changes
    if (old.questionIndex != widget.questionIndex) {
      setState(() => _showHint = false);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(bool correct) async {
  try {
   
    
    // ← release وrecreate على Android بيحل مشكلة التعارض
    await _audioPlayer.setReleaseMode(ReleaseMode.stop);
    
    final asset = correct ? AppAssets.correctSound : AppAssets.wrongSound;
    await _audioPlayer.play(AssetSource(asset));
  } catch (e) {
    debugPrint('Sound error: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    final scoreVm = getIt<ScoreViewModel>();
    final hint    = widget.question.hint;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ─────────────────────────────────────────────────
          Row(
            children: [
              // Text(
              //   'Question ${widget.questionIndex + 1}/${widget.total}',
              //   style: AppStyles.mediumBody,
              // ),
              // const Spacer(),
              // Hint button — only show if hint exists
              if (hint != null && hint.isNotEmpty)
                _HintButton(onTap: () => setState(() => _showHint = !_showHint)),
              
              // SizedBox(width: 8.w),
              const Spacer(),
              const ScoreWidget(),
            ],
          ),
      
          // ── Hint card ──────────────────────────────────────────────────
          if (_showHint && hint != null)
            _HintCard(hint: hint),
      
          SizedBox(height: 50.h),
          Text(widget.question.question, style: AppStyles.largeTitle),
          SizedBox(height: 40.h),
      
          // ── Options ────────────────────────────────────────────────────
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
                  text: option,
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
      ),
    );
  }
}

// ── Hint Button Widget ────────────────────────────────────────────────────
class _HintButton extends StatelessWidget {
  final VoidCallback onTap;
  const _HintButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lightbulb_outline,
                size: 14.sp, color: AppColors.primaryColor.withOpacity(0.9)),
            SizedBox(width: 4.w),
            Text('Hint', style: AppStyles.mediumBody.copyWith(fontSize: 14.sp,color: AppColors.primaryColor.withOpacity(0.9))),
          ],
        ),
      ),
    );
  }
}

// ── Hint Card Widget ──────────────────────────────────────────────────────
class _HintCard extends StatelessWidget {
  final String hint;
  const _HintCard({required this.hint});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(top: 12.h, bottom: 4.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFFE082), width: 1.5),
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
