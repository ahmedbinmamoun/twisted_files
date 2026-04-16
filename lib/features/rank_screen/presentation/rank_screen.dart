import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/di/injection_container.dart';
import 'package:twisted_files/features/common/widgets/app_loading.dart';
import 'package:twisted_files/features/rank_screen/domain/entities/rank_entry_entity.dart';
import 'package:twisted_files/features/rank_screen/domain/use_cases/get_leaderboard_use_case.dart';
import 'package:twisted_files/features/rank_screen/presentation/cubit/rank_cubit.dart';
import 'package:twisted_files/features/rank_screen/presentation/cubit/rank_state.dart';

class RankScreen extends StatelessWidget {
  const RankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RankCubit(
        getLeaderboard: getIt<GetLeaderboardUseCase>(),
      )..load(),
      child: const _RankView(),
    );
  }
}

class _RankView extends StatelessWidget {
  const _RankView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            _Header(),
            Expanded(
              child: BlocBuilder<RankCubit, RankState>(
                builder: (ctx, state) {
                  if (state is RankLoading) {
                    return const AppLoading();
                  }

                  if (state is RankError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wifi_off, color: AppColors.scenderyColor, size: 48.sp),
                          SizedBox(height: 12.h),
                          Text(
                            'Failed to load leaderboard',
                            style: AppStyles.mediumBody.copyWith(color: AppColors.scenderyColor),
                          ),
                          SizedBox(height: 16.h),
                          TextButton(
                            onPressed: () => ctx.read<RankCubit>().load(),
                            child: Text(
                              'Retry',
                              style: AppStyles.mediumBody.copyWith(
                                color: AppColors.scenderyColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is RankLoaded) {
                    return _LeaderboardList(
                      entries:          state.entries,
                      currentUserEntry: state.currentUserEntry,
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 8.h),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.scenderyColor, size: 20.sp),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'LEADERBOARD',
              textAlign: TextAlign.center,
              style: AppStyles.logo.copyWith(
                color: AppColors.scenderyColor,
                fontSize: 28.sp,
              ),
            ),
          ),
          // refresh button
          BlocBuilder<RankCubit, RankState>(
            builder: (ctx, state) => IconButton(
              icon: Icon(
                Icons.refresh,
                color: AppColors.scenderyColor,
                size: 22.sp,
              ),
              onPressed: state is RankLoading ? null : () => ctx.read<RankCubit>().load(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── List ──────────────────────────────────────────────────────────────────────
class _LeaderboardList extends StatelessWidget {
  final List<RankEntryEntity> entries;
  final RankEntryEntity?      currentUserEntry;

  const _LeaderboardList({required this.entries, this.currentUserEntry});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No detectives yet.\nBe the first!',
          textAlign: TextAlign.center,
          style: AppStyles.mediumBody.copyWith(color: AppColors.scenderyColor),
        ),
      );
    }

    return Column(
      children: [
        // ── Top 3 podium ──────────────────────────────────────────────────
        if (entries.length >= 3) _Podium(top3: entries.take(3).toList()),

        SizedBox(height: 8.h),

        // ── Current user sticky card (if not in top visible range) ────────
        if (currentUserEntry != null && currentUserEntry!.rank > 10)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: _RankRow(entry: currentUserEntry!, highlight: true),
          ),

        // ── Full list ─────────────────────────────────────────────────────
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            itemCount: entries.length,
            itemBuilder: (_, i) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _RankRow(
                entry:     entries[i],
                highlight: entries[i].isCurrentUser,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Podium (top 3) ────────────────────────────────────────────────────────────
class _Podium extends StatelessWidget {
  final List<RankEntryEntity> top3;
  const _Podium({required this.top3});

  @override
  Widget build(BuildContext context) {
    // order: 2nd, 1st, 3rd
    final order = [
      if (top3.length > 1) top3[1],
      top3[0],
      if (top3.length > 2) top3[2],
    ];

    final heights = [90.h, 120.h, 70.h];
    final medals  = ['🥈', '🥇', '🥉'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(order.length, (i) {
          final entry  = order[i];
          final medal  = medals[i];
          final height = heights[i];
          final isMine = entry.isCurrentUser;

          return Expanded(
            child: Column(
              children: [
                // Medal
                Text(medal, style: TextStyle(fontSize: 28.sp)),
                SizedBox(height: 4.h),
                // Nickname
                Text(
                  entry.nickname,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.mediumBody.copyWith(
                    color: isMine ? Colors.yellowAccent : AppColors.scenderyColor,
                    fontWeight: isMine ? FontWeight.bold : FontWeight.normal,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                // Podium block
                Container(
                  height: height,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: isMine
                        ? AppColors.scenderyColor
                        : AppColors.scenderyColor.withOpacity(0.15),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
                    border: Border.all(
                      color: AppColors.scenderyColor.withOpacity(0.4),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${entry.totalScore}',
                      style: AppStyles.mediumTitle.copyWith(
                        color: isMine ? AppColors.primaryColor : AppColors.scenderyColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Single Row ────────────────────────────────────────────────────────────────
class _RankRow extends StatelessWidget {
  final RankEntryEntity entry;
  final bool            highlight;

  const _RankRow({required this.entry, this.highlight = false});

  String get _rankLabel {
    switch (entry.rank) {
      case 1: return '🥇';
      case 2: return '🥈';
      case 3: return '🥉';
      default: return '#${entry.rank}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.scenderyColor.withOpacity(0.18)
            : AppColors.scenderyColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: highlight
              ? AppColors.scenderyColor.withOpacity(0.7)
              : AppColors.scenderyColor.withOpacity(0.15),
          width: highlight ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 40.w,
            child: Text(
              _rankLabel,
              textAlign: TextAlign.center,
              style: AppStyles.mediumBody.copyWith(
                color: AppColors.scenderyColor,
                fontSize: entry.rank <= 3 ? 20.sp : 13.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Avatar circle
          CircleAvatar(
            radius: 18.r,
            backgroundColor: AppColors.scenderyColor.withOpacity(0.2),
            child: Text(
              entry.nickname.isNotEmpty ? entry.nickname[0].toUpperCase() : 'D',
              style: AppStyles.mediumTitle.copyWith(
                color: AppColors.scenderyColor,
                fontSize: 14.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.nickname,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.mediumBody.copyWith(
                    color: AppColors.scenderyColor,
                    fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (highlight)
                  Text(
                    'You',
                    style: AppStyles.mediumBody.copyWith(
                      color: AppColors.scenderyColor.withOpacity(0.6),
                      fontSize: 10.sp,
                    ),
                  ),
              ],
            ),
          ),

          // Score
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: highlight
                  ? AppColors.scenderyColor
                  : AppColors.scenderyColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '${entry.totalScore} pts',
              style: AppStyles.mediumBody.copyWith(
                color: highlight ? AppColors.primaryColor : AppColors.scenderyColor,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
