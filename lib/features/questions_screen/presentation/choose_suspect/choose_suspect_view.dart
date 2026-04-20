import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/suspect_entity.dart';
import 'package:twisted_files/features/common/animations/shake_animation.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/questions_screen/presentation/choose_suspect/choose_suspect_cubit.dart';
import 'package:twisted_files/features/questions_screen/presentation/choose_suspect/choose_suspect_state.dart';
import 'package:twisted_files/features/result_dialog/presentation/case_result_dialog.dart';

class ChooseSuspectView extends StatefulWidget {
  final List<SuspectEntity> suspects;
  final String              correctSuspectId;

  const ChooseSuspectView({
    super.key,
    required this.suspects,
    required this.correctSuspectId,
  });

  @override
  State<ChooseSuspectView> createState() => _ChooseSuspectViewState();
}

class _ChooseSuspectViewState extends State<ChooseSuspectView> {
  String? _selectedId;
  bool    _shake = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChooseSuspectCubit, ChooseSuspectState>(
      listener: (ctx, state) async {
        // ── Result ─────────────────────────────────────────────
        if (state is ChooseSuspectDone) {
          await showDialog(
            context: ctx,
            barrierDismissible: false,
            builder: (_) => CaseResultDialog(result: state.result),
          );
        }

        // ── error snackbar ────────────────────────────────────────────────
        if (state is ChooseSuspectError) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text('Something went wrong. Try again.'),
              backgroundColor: AppColors.redColor,
              action: SnackBarAction(
                label:     'Retry',
                textColor: Colors.white,
                onPressed: () => ctx.read<ChooseSuspectCubit>().retryIdle(),
              ),
            ),
          );
        }
      },
      builder: (ctx, state) {
        final isLoading = state is ChooseSuspectLoading;
        final loadingSuspectId = isLoading
            ? (state as ChooseSuspectLoading).selectedSuspect.id
            : null;

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100.h),
                Text('Choose the Suspect', style: AppStyles.logo),
                SizedBox(height: 50.h),

                ...widget.suspects.map((suspect) {
                  final isSelected = _selectedId == suspect.id;
                  final isCorrect  = suspect.id == widget.correctSuspectId;
                  final isThisLoading = loadingSuspectId == suspect.id;

                  Color? borderColor;
                  if (isSelected && !isLoading) {
                    borderColor = isCorrect
                        ? AppColors.greenColor
                        : AppColors.redColor;
                  }

                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: ShakeAnimation(
                      shake: _shake && isSelected && !isCorrect && !isLoading,
                      child: PrimaryButton(
                        borderColor: borderColor,
                        useWidget: isThisLoading,
                        widget: isThisLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width:  20.w,
                                    height: 20.w,
                                    child:  CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.scenderyColor,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'Processing...',
                                    style: AppStyles.mediumButtonText,
                                  ),
                                ],
                              )
                            : null,
                        text: isThisLoading ? null : suspect.name,
                        onPressed: isLoading
                            ? null 
                            : () async {
                                setState(() {
                                  _selectedId = suspect.id;
                                  if (!isCorrect) _shake = true;
                                });
                                await Future.delayed(
                                  const Duration(milliseconds: 400),
                                );
                                if (ctx.mounted) {
                                  ctx
                                      .read<ChooseSuspectCubit>()
                                      .selectSuspect(suspect);
                                }
                              },
                      ),
                    ),
                  );
                }),
              ],
            ),

            if (isLoading)
              Positioned.fill(
                child: AbsorbPointer(
                  absorbing: true,
                  child: Container(color: Colors.transparent),
                ),
              ),
          ],
        );
      },
    );
  }
}
