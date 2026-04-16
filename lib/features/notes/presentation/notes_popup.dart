import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assets.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/features/notes/presentation/cubit/notes_cubit.dart';

class NotesPopup extends StatefulWidget {
  const NotesPopup({super.key});
  @override
  State<NotesPopup> createState() => _NotesPopupState();
}

class _NotesPopupState extends State<NotesPopup> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await context.read<NotesCubit>().updateNote(_controller.text);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.transparentColor,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: BlocListener<NotesCubit, NotesState>(
          listener: (_, state) {
            if (state.text != _controller.text) {
              _controller.text = state.text;
              _controller.selection = TextSelection.fromPosition(
                TextPosition(offset: _controller.text.length),
              );
            }
          },
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.notesBackgroundImage),
                fit: BoxFit.fill,
              ),
            ),
            height: 500.h,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                controller: _controller,
                maxLines: null,
                cursorColor: AppColors.scenderyColor,
                decoration: const InputDecoration(border: InputBorder.none),
                onChanged: (v) => context.read<NotesCubit>().updateNote(v),
                style: AppStyles.mediumTitle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
