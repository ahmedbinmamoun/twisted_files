import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/data/data_source/notes_local_data_source_impl.dart';
import 'package:twisted_files/features/notes/cubit/notes_cubit.dart';
import 'package:twisted_files/features/notes/notes_popup.dart';

class NotesFab extends StatelessWidget {
  final String caseId;
  final double? elevation;

  const NotesFab({
    super.key,
    required this.caseId,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: elevation,
      backgroundColor: AppColors.primaryColor,
      child: Image.asset(AppAssests.notesIcon, width: 40.w,),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) {
            return BlocProvider(
              create: (_) => NotesCubit(
                localDataSource: NotesLocalDataSourceImpl(),
                caseId: caseId,
              ),
              child: const NotesPopup(),
            );
          },
        );
      },
    );
  }
}