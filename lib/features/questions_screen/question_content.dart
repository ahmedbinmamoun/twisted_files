import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/questions_screen/questions_cubit.dart';
import 'package:twisted_files/config/di/config_di.dart';
import 'package:twisted_files/features/score/score_viewmodel.dart';
import 'package:twisted_files/features/score/score_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:twisted_files/features/common/animations/shake_animation.dart';

class QuestionContent extends StatefulWidget {
  final int questionIndex;
  final int total;
  final question;
  final CaseEntity caseEntity;

  const QuestionContent({
    required this.questionIndex,
    required this.total,
    required this.question,
    required this.caseEntity,
  });

  @override
  State<QuestionContent> createState() => _QuestionContentState();
}

class _QuestionContentState extends State<QuestionContent> {
  String? _selectedOption;
  bool _selectedIsCorrect = false;
  bool _disabled = false;
  bool _shake = false; 
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(bool correct) async {
    try {
      final asset = correct ? AppAssests.correctSound : AppAssests.wrongSound;
      await _audioPlayer.play(AssetSource(asset));
    } catch (_) {
    }
  }

  @override
  Widget build(BuildContext context) {
  final scoreVm = getIt<ScoreViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Question ${widget.questionIndex + 1}/${widget.total}',
              style: AppStyles.mediumBody,
            ),
            const Spacer(),
            const ScoreWidget(),
          ],
        ),
        SizedBox(height: 80.h),
        Text(widget.question.question, style: AppStyles.largeTitle),
        SizedBox(height: 50.h),
        ...widget.question.options.map(
          (option) {
            final isSelected = _selectedOption == option;
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
                      _selectedOption = option;
                      _selectedIsCorrect = isCorrect;
                      _disabled = true;
                      if (!isCorrect) _shake = true; 
                    });

                    await _playSound(isCorrect);

                    await scoreVm.answerQuestion(widget.caseEntity, isCorrect);

                    await Future.delayed(const Duration(milliseconds: 500));

                    setState(() {
                      _selectedOption = null;
                      _selectedIsCorrect = false;
                      _disabled = false;
                      _shake = false; 
                    });

                    context.read<QuestionsCubit>().next();
                  },
                ),
              ),
            );
          },
        ).toList(),
      ],
    );
  }
}