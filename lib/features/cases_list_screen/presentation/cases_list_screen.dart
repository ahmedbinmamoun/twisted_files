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
import 'package:twisted_files/features/common/widgets/app_loading.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/score/domain/repositories/score_repository.dart';
import 'package:twisted_files/features/score/presentation/score_view_model.dart';

class CasesListScreen extends StatelessWidget {
  const CasesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final difficulty = ModalRoute.of(context)!.settings.arguments as String;

    return BlocProvider(
      create: (_) => CasesListCubit(
        getCases: getIt<GetCasesByDifficultyUseCase>(),
        canOpenCase: getIt<CanOpenCaseUseCase>(),
        scoreRepository: getIt<ScoreRepository>(),
      )..loadCases(difficulty),
      child: Stack(
        children: [
          Image.asset(AppAssets.backgroundImage, fit: BoxFit.fill),
          Scaffold(
            backgroundColor: AppColors.transparentColor,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: BlocBuilder<CasesListCubit, CasesListState>(
                builder: (context, state) {
                  if (state is CasesListLoading) {
                    return const AppLoading();
                  }
                  if (state is CasesListLoaded) {
                    final cases = state.cases;
                    final totalScore = getIt<ScoreViewModel>().score.totalScore;
                    return ListView.separated(
                      itemCount: cases.length + 1,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (ctx, i) {
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
                        final item = cases[i - 1];
                        final canOpen = ctx.read<CasesListCubit>().canOpen(
                          totalScore,
                          item,
                        );
                        final isCompleted = state.completedCaseIds.contains(
                          item.id,
                        );
                        return PrimaryButton(
                          useWidget: true,
                          widget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.mediumButtonText,
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                              ),
                              if (!canOpen) ...[
                                SizedBox(width: 5.w),
                                Icon(
                                  Icons.lock,
                                  color: AppColors.scenderyColor,
                                ),
                              ] else if (isCompleted) ...[
                                SizedBox(width: 5.w),
                                Icon(
                                  Icons.check_rounded,
                                  color: AppColors.scenderyColor,
                                ), 
                              ],
                            ],
                          ),
                          onPressed: () {
                            if (canOpen) {
                              Navigator.pushNamed(
                                ctx,
                                AppRoutes.caseOverViewScreen,
                                arguments: {
                                  'caseId': item.id,
                                  'difficulty': difficulty,
                                },
                              );
                            } else {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'You need ${item.unlockRole.requiredScore} points to unlock this case',
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                  if (state is CasesListError) {
                    return Center(child: Text(state.message));
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
