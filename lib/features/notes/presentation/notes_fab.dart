import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assets.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/features/notes/data/data_sources/notes_local_data_source.dart';
import 'package:twisted_files/features/notes/presentation/cubit/notes_cubit.dart';
import 'package:twisted_files/features/notes/presentation/notes_popup.dart';

class NotesFab extends StatelessWidget {
  final String caseId;
  final double? elevation;

  const NotesFab({super.key, required this.caseId, this.elevation});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: elevation,
      backgroundColor: AppColors.primaryColor,
      child: Image.asset(AppAssets.notesIcon, width: 40.w),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => BlocProvider(
            create: (_) => NotesCubit(
              repository: NotesLocalDataSource(),
              caseId: caseId,
            ),
            child: const NotesPopup(),
          ),
        );
      },
    );
  }
}
