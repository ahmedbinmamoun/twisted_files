import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/services/rewarded_ad_service.dart';
import 'package:twisted_files/core/di/injection_container.dart';
import 'package:twisted_files/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/profile_screen/presentation/cubit/profile_cubit.dart';
import 'package:twisted_files/features/profile_screen/presentation/cubit/profile_state.dart';

class NicknameDialog extends StatefulWidget {
  final String initialNickname;

  const NicknameDialog({super.key, required this.initialNickname});

  @override
  State<NicknameDialog> createState() => _NicknameDialogState();
}

class _NicknameDialogState extends State<NicknameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNickname);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) =>
          prev.nicknameStatus != curr.nicknameStatus,
      listener: (ctx, state) {
        if (state.nicknameStatus == NicknameStatus.success) {
          // ── اعمل update للـ AuthCubit بالاسم الجديد ────────────────────
          ctx.read<AuthCubit>().updateNickname(_controller.text.trim());

          // ── اعرض الـ ad بعد تغيير الاسم ─────────────────────────────────
          getIt<RewardedAdService>().showAd(onRewarded: () {});

          Navigator.pop(ctx);
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(content: Text('Nickname updated ✓')),
          );

          ctx.read<ProfileCubit>().resetNicknameStatus();
        }
      },
      builder: (ctx, state) {
        final isLoading = state.nicknameStatus == NicknameStatus.loading;
        final error     = state.nicknameError.isNotEmpty ? state.nicknameError : null;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Top indicator ──────────────────────────────────────────
                Container(
                  width: 40.w, height: 4.h,
                  decoration: BoxDecoration(
                    color:        AppColors.greyColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 16.h),

                // ── Title ──────────────────────────────────────────────────
                Text('Edit Nickname', style: AppStyles.largeTitle),
                SizedBox(height: 8.h),
                Text(
                  'Choose a unique nickname',
                  style: AppStyles.largeBody.copyWith(
                    color: AppColors.greyColor,
                  ),
                ),
                SizedBox(height: 20.h),

                // ── Input ──────────────────────────────────────────────────
                TextField(
                  controller: _controller,
                  maxLength:  20,
                  style:      AppStyles.mediumBody,
                  decoration: InputDecoration(
                    hintText:       'Enter nickname...',
                    hintStyle:      AppStyles.mediumBody.copyWith(
                      color: AppColors.hintTextColor,
                    ),
                    filled:         true,
                    fillColor:      AppColors.offWhiteColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide:   BorderSide.none,
                    ),
                    errorText: error,
                  ),
                ),

                // ── Loading bar ────────────────────────────────────────────
                if (isLoading) ...[
                  SizedBox(height: 8.h),
                  LinearProgressIndicator(color: AppColors.primaryColor),
                ],

                SizedBox(height: 20.h),

                // ── Buttons ────────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text:            'Cancel',
                        onPressed:       isLoading ? null : () {
                          ctx.read<ProfileCubit>().resetNicknameStatus();
                          Navigator.pop(ctx);
                        },
                        backgroundColor: Colors.transparent,
                        borderColor:     AppColors.greyColor,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: PrimaryButton(
                        onPressed:  isLoading ? null : () {
                          ctx.read<ProfileCubit>().saveNickname(
                            _controller.text,
                          );
                        },
                        useWidget:  isLoading,
                        text:       isLoading ? null : 'Save',
                        widget:     const SizedBox(
                          height: 18, width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
