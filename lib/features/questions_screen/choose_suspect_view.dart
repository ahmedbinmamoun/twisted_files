import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/domain/entities/suspect_entity.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';

class ChooseSuspectView extends StatelessWidget {
  final List<SuspectEntity> suspects;
  final Function(SuspectEntity) onSelect;

  const ChooseSuspectView({
    required this.suspects,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 100.h),
        Text(
          'Choose the Suspect',
          style: AppStyles.logo,
        ),

        SizedBox(height: 50.h),

        ...suspects.map(
          (suspect) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: PrimaryButton(
              text: suspect.name,
              onPressed: () => onSelect(suspect),
            ),
          ),
        ),
      ],
    );
  }
}