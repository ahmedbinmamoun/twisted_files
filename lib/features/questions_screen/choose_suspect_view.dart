import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/domain/entities/suspect_entity.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/common/animations/shake_animation.dart';

class ChooseSuspectView extends StatefulWidget {
  final List<SuspectEntity> suspects;
  final Function(SuspectEntity) onSelect;
  final String? correctSuspectId;

  const ChooseSuspectView({
    super.key,
    required this.suspects,
    required this.onSelect,
    this.correctSuspectId,
  });

  @override
  State<ChooseSuspectView> createState() => _ChooseSuspectViewState();
}

class _ChooseSuspectViewState extends State<ChooseSuspectView> {
  String? _selectedSuspectId;
  bool _shake = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 100.h),
          Text(
            'Choose the Suspect',
            style: AppStyles.logo,
          ),
          SizedBox(height: 50.h),
          ...widget.suspects.map(
            (suspect) {
              final isSelected = _selectedSuspectId == suspect.id;
              final isCorrect = widget.correctSuspectId != null && widget.correctSuspectId == suspect.id;
              final borderColor = isSelected ? (isCorrect ? AppColors.greenColor : AppColors.redColor) : null;

              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: ShakeAnimation(
                  shake: _shake && isSelected && !isCorrect,
                  child: PrimaryButton(
                    borderColor: borderColor,
                    text: suspect.name,
                    onPressed: () async {
                      if (_selectedSuspectId != null) return;
                      setState(() => _selectedSuspectId = suspect.id);

                      if (!isCorrect) {
                        setState(() => _shake = true);
                        await Future.delayed(const Duration(milliseconds: 500));
                        setState(() => _shake = false);
                        await Future.delayed(const Duration(milliseconds: 100));
                      } else {
                        await Future.delayed(const Duration(milliseconds: 500));
                      }

                      widget.onSelect(suspect);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}