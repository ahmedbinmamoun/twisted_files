import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/domain/entities/suspect_entity.dart';
import 'package:twisted_files/features/common/animations/shake_animation.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';

class ChooseSuspectView extends StatefulWidget {
  final List<SuspectEntity> suspects;
  final Function(SuspectEntity) onSelect;
  final String correctSuspectId;
  

  const ChooseSuspectView({
    super.key,
    required this.suspects,
    required this.onSelect,
    required this.correctSuspectId,
  });

  @override
  State<ChooseSuspectView> createState() => _ChooseSuspectViewState();
}

class _ChooseSuspectViewState extends State<ChooseSuspectView> {
  SuspectEntity? selectedSuspect;
  bool _shake = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 100.h),
        Text('Choose the Suspect', style: AppStyles.logo),
        SizedBox(height: 50.h),

        ...widget.suspects.map((suspect) {
          final isSelected = selectedSuspect?.id == suspect.id;
          final isCorrect =
              suspect.id == widget.correctSuspectId;

          Color? borderColor;

          if (isSelected) {
            borderColor = isCorrect ? AppColors.greenColor : AppColors.redColor;
          }

          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: ShakeAnimation(
              shake: _shake && isSelected && !isCorrect,
              child: PrimaryButton(
                text: suspect.name,
                borderColor: borderColor, 
                onPressed: selectedSuspect == null
                    ? () async{
                        setState(() {
                          selectedSuspect = suspect;
                          if (!isCorrect) _shake = true;
                          
                        });
                        await Future.delayed(const Duration(milliseconds: 500));
              
                        widget.onSelect(suspect);
                      }
                    : null, 
              ),
            ),
          );
        }),
      ],
    );
  }
}