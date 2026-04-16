import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/di/injection_container.dart';
import 'package:twisted_files/core/navigation/app_navigator.dart';
import 'package:twisted_files/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twisted_files/features/auth/presentation/cubit/auth_state.dart';
import 'package:twisted_files/features/common/widgets/app_loading.dart';
import 'package:twisted_files/features/profile_screen/presentation/cubit/profile_cubit.dart';
import 'package:twisted_files/features/profile_screen/presentation/cubit/profile_state.dart';
import 'package:twisted_files/features/profile_screen/presentation/widgets/detective_card.dart';
import 'package:twisted_files/features/profile_screen/presentation/widgets/google_sign_in_button.dart';
import 'package:twisted_files/features/profile_screen/presentation/widgets/nickname_dialog.dart';
import 'package:twisted_files/features/profile_screen/presentation/widgets/profile_header_widget.dart';
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
    super.initState();
    Future.microtask(() => context.read<ProfileCubit>().loadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: _handleAuthState,
          builder:  (authCtx, authState) {
            return AnimatedBuilder(
              animation: getIt<ScoreViewModel>(),
              builder: (_, __) => SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (ctx, profileState) {
                    if (profileState.isLoading) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: const AppLoading(),
                      );
                    }

                    final profile = authState is AuthSignedIn
                        ? authState.profile
                        : null;
                    final isAnon = profile?.isAnonymous ?? true;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Header ─────────────────────────────────────────
                        ProfileHeaderWidget(
                          profile:   profile,
                          onEditTap: () => _openNicknameDialog(ctx, profile?.nickname ?? ''),
                        ),
                        SizedBox(height: 24.h),

                        // ── Stats row ──────────────────────────────────────
                        Row(
                          children: [
                            Expanded(
                              child: ProfileStatBox(
                                title: 'Total Score',
                                value: getIt<ScoreViewModel>()
                                    .score
                                    .totalScore
                                    .toString(),
                                onTap: () {},
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: ProfileStatBox(
                                title: 'Rank',
                                value: profileState.userRank > 0
                                    ? '#${profileState.userRank}'
                                    : '—',
                                isRank: true,
                                onTap:  () => AppNavigator.push(
                                  ctx,
                                  const RankScreen(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),

                        // ── Detective card ─────────────────────────────────
                        RepaintBoundary(child: DetectiveCard(stats: profileState.stats)),
                        SizedBox(height: 32.h),

                        // ── Google Sign-in (guests only) ───────────────────
                        // if (isAnon)
                        //   GoogleSignInButton(
                        //     isLoading: authState is AuthLoading,
                        //     onPressed: authState is AuthLoading
                        //         ? null
                        //         : () => authCtx
                        //             .read<AuthCubit>()
                        //             .signInWithGoogle(),
                        //   ),
                      ],
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

  // ── Handlers — UI side effects  ───────────────────────────────────────

  void _handleAuthState(BuildContext ctx, AuthState state) {
    if (state is AuthError) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content:         Text(state.message),
          backgroundColor: AppColors.redColor,
        ),
      );
    }
    if (state is AuthSignedIn && !state.profile.isAnonymous) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Signed in with Google ✓')),
      );
    }
  }

  void _openNicknameDialog(BuildContext ctx, String currentNickname) {
    showDialog(
      context: ctx,
      builder: (_) => BlocProvider.value(
        value: ctx.read<ProfileCubit>(),
        child: BlocProvider.value(
          value: ctx.read<AuthCubit>(),
          child: NicknameDialog(initialNickname: currentNickname),
        ),
      ),
    );
  }
}
