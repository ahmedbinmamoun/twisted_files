import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_style.dart';

class A4Header extends StatelessWidget {
  final String caseNumber;
  final String date;
  final String location;
  final String title;

  const A4Header({
    super.key,
    required this.caseNumber,
    required this.date,
    required this.location,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CASE FILE",
          style: AppStyles.mediumTitle,
        ),
         SizedBox(height: 4.h),
         Text("case: $title",
         style: AppStyles.mediumBody,
         ),
         SizedBox(height: 2.h),
        Text(
          "No: $caseNumber | $date | $location",
          style: AppStyles.mediumBody,
        ),
      ],
    );
  }
}