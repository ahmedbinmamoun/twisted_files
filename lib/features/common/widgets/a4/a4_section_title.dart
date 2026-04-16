import 'package:flutter/material.dart';
import 'package:twisted_files/core/constants/app_style.dart';

class A4SectionTitle extends StatelessWidget {
  final String title;
  const A4SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(title.toUpperCase(), style: AppStyles.mediumTitle),
    );
  }
}
