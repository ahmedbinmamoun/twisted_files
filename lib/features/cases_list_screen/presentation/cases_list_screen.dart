import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assets.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/di/injection_container.dart';
import 'package:twisted_files/core/navigation/app_routes.dart';
import 'package:twisted_files/features/cases_list_screen/domain/use_cases/can_open_case_use_case.dart';
import 'package:twisted_files/features/cases_list_screen/domain/use_cases/get_cases_by_difficulty_use_case.dart';
import 'package:twisted_files/features/cases_list_screen/presentation/cubit/cases_list_cubit.dart';
import 'package:twisted_files/features/cases_list_screen/presentation/cubit/cases_list_state.dart';
import 'package:twisted_files/features/common/widgets/app_dialog.dart';
import 'package:twisted_files/features/common/widgets/app_loading.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/score/domain/repositories/score_repository.dart';
import 'package:twisted_files/features/score/presentation/score_view_model.dart';
import 'package:twisted_files/core/services/rewarded_ad_service.dart';
 
class CasesListScreen extends StatefulWidget {
  const CasesListScreen({super.key});
 
  @override
  State<CasesListScreen> createState() => _CasesListScreenState();
}
 
class _CasesListScreenState extends State<CasesListScreen> {
  final ScrollController _scrollController = ScrollController();
 
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }
 
  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
 
  /// لما يوصل لـ 80% من الـ list — جيب الصفحة الجاية
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current   = _scrollController.position.pixels;
    if (current >= maxScroll * 0.8) {
      context.read<CasesListCubit>().loadMore();
    }
  }
 
  @override
  Widget build(BuildContext context) {
    final difficulty = ModalRoute.of(context)!.settings.arguments as String;
 
    return BlocProvider(
      create: (_) => CasesListCubit(
        getCases:        getIt<GetCasesByDifficultyUseCase>(),
        canOpenCase:     getIt<CanOpenCaseUseCase>(),
        scoreRepository: getIt<ScoreRepository>(),
      )..loadCases(difficulty),
      child: Stack(
        children: [
          // ── Background ─────────────────────────────────────────────────────
          RepaintBoundary(
            child: LayoutBuilder(
              builder: (_, constraints) => Image.asset(
                AppAssets.backgroundImage,
                fit:         BoxFit.fill,
                cacheWidth:  constraints.maxWidth.toInt(),
                cacheHeight: constraints.maxHeight.toInt(),
              ),
            ),
          ),
 
          Scaffold(
            backgroundColor: AppColors.transparentColor,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: BlocBuilder<CasesListCubit, CasesListState>(
                builder: (ctx, state) {
                  // ── First load ──────────────────────────────────────────────
                  if (state is CasesListLoading) {
                    return const AppLoading();
                  }
 
                  // ── Error ───────────────────────────────────────────────────
                  if (state is CasesListError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.message, style: AppStyles.mediumBody),
                          SizedBox(height: 12.h),
                          PrimaryButton(
                            text:      'Retry',
                            onPressed: () => ctx
                                .read<CasesListCubit>()
                                .loadCases(difficulty),
                          ),
                        ],
                      ),
                    );
                  }
 
                  // ── Loaded ──────────────────────────────────────────────────
                  if (state is CasesListLoaded) {
                    final cases      = state.cases;
                    final totalScore = getIt<ScoreViewModel>().score.totalScore;
 
                    return ListView.separated(
                      controller:      _scrollController,
                      // header + cases + (loading indicator lو isLoadingMore)
                      itemCount:       cases.length + 1 + (state.isLoadingMore ? 1 : 0),
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (ctx, i) {
 
                        // ── Header ────────────────────────────────────────────
                        if (i == 0) {
                          return Padding(
                            padding: EdgeInsets.only(top: 80.h, bottom: 30.h),
                            child: Center(
                              child: Text(
                                '${difficulty.toUpperCase()} CASES',
                                style: AppStyles.logo,
                              ),
                            ),
                          );
                        }
 
                        // ── Loading more indicator ────────────────────────────
                        if (i == cases.length + 1) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: const AppLoading(size: 60),
                          );
                        }
 
                        // ── Case item ─────────────────────────────────────────
                        final item         = cases[i - 1];
                        final canOpen      = ctx.read<CasesListCubit>().canOpen(totalScore, item);
                        final isCompleted  = state.completedCaseIds.contains(item.id);
                        final isAdUnlocked = state.unlockedCaseIds.contains(item.id);
                        final isAccessible = canOpen || isAdUnlocked;
 
                        return PrimaryButton(
                          useWidget: true,
                          widget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  textAlign: TextAlign.center,
                                  style:     AppStyles.mediumButtonText,
                                  maxLines:  2,
                                  softWrap:  true,
                                ),
                              ),
                              // ── Status icon ─────────────────────────────────
                              if (isCompleted) ...[
                                SizedBox(width: 5.w),
                                Icon(Icons.check_rounded,   color: AppColors.scenderyColor),
                              ] else if (isAdUnlocked) ...[
                                SizedBox(width: 5.w),
                                Icon(Icons.play_arrow_rounded, color: AppColors.scenderyColor),
                              ] else if (!canOpen) ...[
                                SizedBox(width: 5.w),
                                Icon(Icons.lock,            color: AppColors.scenderyColor),
                              ],
                            ],
                          ),
                          onPressed: () {
                            if (isAccessible) {
                              Navigator.pushNamed(
                                ctx,
                                AppRoutes.caseOverViewScreen,
                                arguments: {
                                  'caseId':     item.id,
                                  'difficulty': difficulty,
                                },
                              );
                            } else {
                              _showUnlockDialog(ctx, item.id, item.unlockRole.requiredScore);
                            }
                          },
                        );
                      },
                    );
                  }
 
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  void _showUnlockDialog(BuildContext context, String caseId, int requiredScore) {
    final cubit = context.read<CasesListCubit>();
 
    AppDialog.show(
      context,
      imagePath:          AppAssets.detectiveIcon,
      title:              'Case Locked 🔒',
      summary:            'You need $requiredScore points to unlock this case.\n\nWatch a short ad to unlock it for free!',
      barrierDismissible: true,
      actions: [
        AppDialogAction(
          label:     'No thanks',
          onPressed: () => Navigator.pop(context),
        ),
        AppDialogAction(
          label:     'Watch Ad 📺',
          isPrimary: true,
          onPressed: () {
            Navigator.pop(context);
            getIt<RewardedAdService>().showAd(
              onRewarded: () {
                cubit.unlockCaseTemporarily(caseId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:         const Text('Case unlocked! 🎉'),
                    backgroundColor: AppColors.greenColor,
                    duration:        const Duration(seconds: 2),
                  ),
                );
              },
              onNotReady: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:         const Text('Ad not available. Try again later.'),
                    backgroundColor: AppColors.redColor,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
 