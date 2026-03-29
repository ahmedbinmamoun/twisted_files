import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assets.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/di/injection_container.dart';
import 'package:twisted_files/core/navigation/app_navigator.dart';
import 'package:twisted_files/features/auth/domain/use_cases/update_nickname_use_case.dart';
import 'package:twisted_files/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twisted_files/features/auth/presentation/cubit/auth_state.dart';
import 'package:twisted_files/features/common/widgets/app_loading.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/common/widgets/rewarded_ad.dart';
import 'package:twisted_files/features/profile_screen/presentation/cubit/profile_cubit.dart';
import 'package:twisted_files/features/profile_screen/presentation/cubit/profile_state.dart';
import 'package:twisted_files/features/profile_screen/presentation/widgets/detective_card.dart';
import 'package:twisted_files/features/profile_screen/presentation/widgets/profile_stat_box.dart';
import 'package:twisted_files/features/rank_screen/presentation/rank_screen.dart';
import 'package:twisted_files/features/score/presentation/score_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
  
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRewardedAd();
    Future.microtask((){
      context.read<ProfileCubit>().loadProfile();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: getIt<ScoreViewModel>(),
          builder: (ctx, _) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (_, profileState) {
                    if (profileState.isLoading) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: const AppLoading());
                    }
                    return BlocConsumer<AuthCubit, AuthState>(
                      listener: (ctx, authState) {
                        if (authState is AuthError) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(content: Text(authState.message)),
                          );
                        }
                        if (authState is AuthSignedIn && !authState.profile.isAnonymous) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(content: Text('Signed in with Google ✓')),
                          );
                        }
                      },
                      builder: (ctx, authState) {
                        final profile  = authState is AuthSignedIn ? authState.profile : null;
                        final nickname = profile?.nickname ?? 'Detective';
                        final isAnon   = profile?.isAnonymous ?? true;
              
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
              
                            // ── Avatar + Name + Edit ────────────────────────
                            Row(
                              children: [
                                if (profile?.avatarUrl != null)
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(profile!.avatarUrl!),
                                    radius: 24.r,
                                  )
                                else
                                  CircleAvatar(
                                    backgroundColor: AppColors.primaryColor,
                                    radius: 24.r,
                                    child: Text(
                                      nickname.isNotEmpty ? nickname[0].toUpperCase() : 'D',
                                      style: TextStyle(
                                        color: AppColors.scenderyColor,
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 12.w),
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
                                              text: nickname,
                                              style: AppStyles.largeTitle
                                                  .copyWith(color: AppColors.primaryColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isAnon)
                                        Text(
                                          'Guest account',
                                          style: AppStyles.mediumBody.copyWith(
                                            color: AppColors.hintTextColor,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit, size: 18.sp),
                                  onPressed: () => _showEditNicknameDialog(ctx, nickname),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
              
                            
              
                            // ── Stats row ───────────────────────────────────
                            Row(
                              children: [
                                // Total Score card
                                Expanded(
                                  child: ProfileStatBox(
                                    title: 'Total Score',
                                    // ← real score from ScoreViewModel (live)
                                    value: getIt<ScoreViewModel>().score.totalScore.toString(),
                                    onTap: () {},
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                // Rank card — real rank, tappable
                                Expanded(
                                  child: ProfileStatBox(
                                    title: 'Rank',
                                    // ← real rank: show # or "—" while loading
                                    value: profileState.userRank > 0
                                        ? '#${profileState.userRank}'
                                        : '—',
                                    isRank: true,
                                    // ← navigate to RankScreen
                                    onTap: () => AppNavigator.push(ctx, const RankScreen()),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 32.h),
              
                            // ── Detective card ──────────────────────────────
                            DetectiveCard(stats: profileState.stats),
              
                            SizedBox(height: 300.h),
                            // ── Google Sign-in ──────────────────────────────
                            if (isAnon)
                              _GoogleSignInButton(
                                isLoading: authState is AuthLoading,
                                onPressed: authState is AuthLoading
                                    ? null
                                    : () => ctx.read<AuthCubit>().signInWithGoogle(),
                              ),
              
                            // SizedBox(height: 24.h),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Edit nickname dialog with uniqueness check ──────────────────────────
  void _showEditNicknameDialog(BuildContext context, String current) {
    final controller = TextEditingController(text: current);

    showDialog(
      context: context,
      builder: (dialogCtx) => _NicknameDialog(
        controller: controller,
        authCubit:  context.read<AuthCubit>(),
      ),
    );
  }
}

// ── Nickname Dialog (StatefulWidget for loading state) ───────────────────────
class _NicknameDialog extends StatefulWidget {
  final TextEditingController controller;
  final AuthCubit authCubit;

  const _NicknameDialog({
    required this.controller,
    required this.authCubit,
  });

  @override
  State<_NicknameDialog> createState() => _NicknameDialogState();
}

class _NicknameDialogState extends State<_NicknameDialog> {
  bool _loading = false;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Top indicator (nice touch)
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 16),

            /// Title
             Text(
              'Edit Nickname',
              style: AppStyles.largeTitle
            ),

            const SizedBox(height: 8),

             Text(
              'Choose a unique nickname',
              style: AppStyles.largeBody.copyWith(color: AppColors.greyColor),
            ),

            const SizedBox(height: 20),

            /// Input
            TextField(
              controller: widget.controller,
              maxLength: 20,
              decoration: InputDecoration(
                hintText: 'Enter nickname...',
                filled: true,
                fillColor: AppColors.offWhiteColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                errorText: _error.isEmpty ? null : _error,
              ),
            ),

            const SizedBox(height: 10),

            /// Loading
            if (_loading)
              const LinearProgressIndicator(),

            const SizedBox(height: 20),

            /// Buttons
            Row(
  children: [
    /// Cancel
    Expanded(
      child: PrimaryButton(
        text: 'Cancel',
        onPressed: _loading ? null : () => Navigator.pop(context),
        backgroundColor: Colors.transparent,
        borderColor: Colors.grey,
      ),
    ),

    SizedBox(width: 10.w),

    /// Save
    Expanded(
      child: PrimaryButton(
        onPressed: _loading ? null : () => _save(context),
        useWidget: _loading,
        text: _loading ? null : 'Save',
        widget: const SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        ),
      ),
    ),
  ],
)
          
          ],
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    final name = widget.controller.text.trim();

    if (name.length < 3) {
      setState(() => _error = 'Minimum 3 characters');
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
    });

    final result = await getIt<UpdateNicknameUseCase>().call(name);

    if (result == NicknameUpdateResult.success) {
      showRewardedAd();
    }

    if (!mounted) return;

    switch (result) {
      case NicknameUpdateResult.success:
        widget.authCubit.updateNickname(name);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nickname updated ✓')),
        );
        break;

      case NicknameUpdateResult.taken:
        setState(() {
          _loading = false;
          _error = 'Name already taken';
        });
        break;

      case NicknameUpdateResult.tooShort:
        setState(() {
          _loading = false;
          _error = 'Minimum 3 characters';
        });
        break;

      case NicknameUpdateResult.unchanged:
        Navigator.pop(context);
        break;
    }
  }
}

// ── Google Sign-in Button ─────────────────────────────────────────────────────
class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool          isLoading;
  const _GoogleSignInButton({required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:  double.infinity,
      height: 48.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side:  BorderSide(color: AppColors.primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w, height: 20.h,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryColor),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20.w, height: 20.h,
                    decoration: BoxDecoration(
                      color:        Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Image.asset(AppAssets.googleIcon,width: 20.w,)

                      // Text(
                      //   'G',
                      //   style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14.sp),
                      // ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Sign in with Google',
                    style: AppStyles.mediumBody.copyWith(
                      color:      AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
