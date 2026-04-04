import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/features/auth/domain/entities/user_profile_entity.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserProfileEntity? profile;
  final VoidCallback        onEditTap;

  const ProfileHeaderWidget({
    super.key,
    required this.profile,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final nickname = profile?.nickname ?? 'Detective';
    final isAnon   = profile?.isAnonymous ?? true;

    return Row(
      children: [
        // ── Avatar ───────────────────────────────────────────────────────
        _Avatar(profile: profile, nickname: nickname),
        SizedBox(width: 12.w),

        // ── Name + guest badge ───────────────────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: AppStyles.largeTitle,
                  children: [
                    const TextSpan(text: 'Detective '),
                    TextSpan(
                      text:  nickname,
                      style: AppStyles.largeTitle
                          .copyWith(color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),
              if (isAnon)
                Text(
                  'Guest account',
                  style: AppStyles.smallBody.copyWith(
                    color: AppColors.hintTextColor,
                  ),
                ),
            ],
          ),
        ),

        // ── Edit button ──────────────────────────────────────────────────
        IconButton(
          icon: Icon(Icons.edit, size: 20.sp, color: AppColors.primaryColor),
          onPressed: onEditTap,
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final UserProfileEntity? profile;
  final String             nickname;

  const _Avatar({required this.profile, required this.nickname});

  @override
  Widget build(BuildContext context) {
    if (profile?.avatarUrl != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(profile!.avatarUrl!),
        radius: 28.r,
      );
    }
    return CircleAvatar(
      backgroundColor: AppColors.primaryColor,
      radius: 28.r,
      child: Text(
        nickname.isNotEmpty ? nickname[0].toUpperCase() : 'D',
        style: AppStyles.mediumTitle.copyWith(color: AppColors.scenderyColor),
      ),
    );
  }
}
