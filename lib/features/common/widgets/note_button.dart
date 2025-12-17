import 'package:flutter/material.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_colors.dart';

class NoteButton extends StatelessWidget {
  const NoteButton({super.key});
  

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){},
    backgroundColor: AppColors.primaryColor,
    child: Image.asset(AppAssests.notesIcon),
    );
  }
}