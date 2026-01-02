import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/features/notes/cubit/notes_cubit.dart';

class NotesPopup extends StatefulWidget {
  const NotesPopup({super.key});

  @override
  State<NotesPopup> createState() => _NotesPopupState();
}

class _NotesPopupState extends State<NotesPopup> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await context.read<NotesCubit>().updateNote(controller.text);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.transparentColor,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: BlocListener<NotesCubit, NotesState>(
          listener: (context, state) {
            if (state.text != controller.text) {
              controller.text = state.text;
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            }
          },
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssests.notesBackgroundImage),
                fit: BoxFit.fill,
              ),
            ),
            height: 500.h,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                controller: controller,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  context.read<NotesCubit>().updateNote(value);
                },
                style: AppStyles.mediumTitle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}