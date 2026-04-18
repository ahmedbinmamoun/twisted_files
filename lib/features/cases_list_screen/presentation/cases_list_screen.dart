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
  late String _difficulty;
  late CasesListCubit    _cubit; 
 
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
 
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max     = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= max * 0.8) {
      _cubit.loadMore(); 
    }
  }
 
  // ── Error Dialog ──────────────────────────────────────────────────────────
 
  void _showErrorDialog(BuildContext ctx, String message) {
    final isNoInternet = message == 'no_internet';
 
    // addPostFrameCallback عشان ما يحصلش conflict مع الـ build cycle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      AppDialog.show(
        ctx,
        barrierDismissible: false,
        title:              isNoInternet
            ? 'No Internet Connection 📡'
            : 'Failed to Load Cases',
        summary:            isNoInternet
            ? 'Please check your connection\nand try again.'
            : 'Something went wrong.\nPlease try again.',
        actions: [
          AppDialogAction(
            label:     'Go Back',
            onPressed: () {
              Navigator.pop(ctx); 
              Navigator.pop(ctx); 
            },
          ),
          AppDialogAction(
            label:     'Try Again',
            isPrimary: true,
            onPressed: () {
              Navigator.pop(ctx); 
              ctx.read<CasesListCubit>().loadCases(_difficulty);
            },
          ),
        ],
      );
    });
  }
 
  // ── Unlock Dialog ─────────────────────────────────────────────────────────
 
  void _showUnlockDialog(BuildContext ctx, String caseId, int requiredScore) {
    final cubit = ctx.read<CasesListCubit>();
 
    AppDialog.show(
      ctx,
      title:              'Case Locked 🔒',
      summary:            'You need $requiredScore points to unlock this case.\n\nWatch a short ad to unlock it for free!',
      barrierDismissible: true,
      actions: [
        AppDialogAction(
          label:     'No thanks',
          onPressed: () => Navigator.pop(ctx),
        ),
        AppDialogAction(
          label:     'Watch Ad 📺',
          isPrimary: true,
          onPressed: () {
            Navigator.pop(ctx);
            getIt<RewardedAdService>().showAd(
              onRewarded: () {
                cubit.unlockCaseTemporarily(caseId);
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(
                    content:         const Text('Case unlocked! 🎉'),
                    backgroundColor: AppColors.greenColor,
                    duration:        const Duration(seconds: 2),
                  ),
                );
              },
              onNotReady: () {
                ScaffoldMessenger.of(ctx).showSnackBar(
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
 
  @override
  Widget build(BuildContext context) {
    _difficulty = ModalRoute.of(context)!.settings.arguments as String;
 
    return BlocProvider(
      create: (_) {
        // ← احفظ الـ cubit هنا
        _cubit = CasesListCubit(
          getCases:        getIt<GetCasesByDifficultyUseCase>(),
          canOpenCase:     getIt<CanOpenCaseUseCase>(),
          scoreRepository: getIt<ScoreRepository>(),
        )..loadCases(_difficulty);
        return _cubit;
      },
      child: Stack(
        children: [
          // ── Background ───────────────────────────────────────────────────
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
              child: BlocConsumer<CasesListCubit, CasesListState>(
 
                // ── Listener — side effects فقط ──────────────────────────
                listener: (ctx, state) {
                  if (state is CasesListError) {
                    _showErrorDialog(ctx, state.message);
                  }
                },
 
                // ── Builder — UI فقط ─────────────────────────────────────
                builder: (ctx, state) {
 
                  // First load
                  if (state is CasesListLoading) {
                    return const AppLoading();
                  }
 
                  // Error — الـ dialog بيتعرض في الـ listener
                  // بس نحط loading بدل ما نسيب الشاشة فاضية
                  if (state is CasesListError) {
                    return const AppLoading();
                  }
 
                  if (state is CasesListLoaded) {
                    final cases      = state.cases;
                    final totalScore = getIt<ScoreViewModel>().score.totalScore;
 
                    return ListView.separated(
                      controller:   _scrollController,
                      itemCount:    cases.length + 1 + (state.isLoadingMore ? 1 : 0),
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (ctx, i) {
 
                        // Header
                        if (i == 0) {
                          return Padding(
                            padding: EdgeInsets.only(top: 80.h, bottom: 30.h),
                            child: Center(
                              child: Text(
                                '${_difficulty.toUpperCase()} CASES',
                                style: AppStyles.logo,
                              ),
                            ),
                          );
                        }
 
                        // Loading more indicator
                        if (i == cases.length + 1) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: const AppLoading(size: 60),
                          );
                        }
 
                        // Case item
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
                              if (isCompleted) ...[
                                SizedBox(width: 5.w),
                                Icon(Icons.check_rounded,
                                    color: AppColors.scenderyColor),
                              ] else if (isAdUnlocked) ...[
                                SizedBox(width: 5.w),
                                Icon(Icons.play_arrow_rounded,
                                    color: AppColors.scenderyColor),
                              ] else if (!canOpen) ...[
                                SizedBox(width: 5.w),
                                Icon(Icons.lock,
                                    color: AppColors.scenderyColor),
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
                                  'difficulty': _difficulty,
                                },
                              );
                            } else {
                              _showUnlockDialog(
                                ctx,
                                item.id,
                                item.unlockRole.requiredScore,
                              );
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
}
 