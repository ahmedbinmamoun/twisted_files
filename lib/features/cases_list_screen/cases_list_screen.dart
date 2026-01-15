import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/navigation/app_routes.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/domain/use_cases/can_open_case_use_case.dart';
import 'package:twisted_files/features/cases_list_screen/cubit/cases_level_cubit.dart';
import 'package:twisted_files/features/cases_list_screen/cubit/cases_list_state.dart'
    hide CasesListCubit;
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/score/score_cubit/score_cubit.dart';

class CasesListScreen extends StatelessWidget {
  final CaseRepository repository;

  const CasesListScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final difficulty = ModalRoute.of(context)!.settings.arguments as String;

    return BlocProvider(
      create: (_) =>
          CasesListCubit(repository)..loadCasesByDifficulty(difficulty),
      child: Stack(
        children: [
          Image.asset(AppAssests.backgroundImage, fit: BoxFit.fill),
          Scaffold(
            backgroundColor: AppColors.transparentColor,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: BlocBuilder<CasesListCubit, CasesListState>(
                builder: (context, state) {
                  if (state is CasesListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CasesListLoaded) {
                    final cases = state.cases;

                    return ListView.separated(
                      itemCount: cases.length + 1,
                      separatorBuilder: (context, _) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        if (index == 0) {
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

                        final caseItem = cases[index - 1];
                        final totalScore = context
                            .watch<ScoreCubit>()
                            .state
                            .score
                            .totalScore;
                        final canOpen = CanOpenCaseUseCase().call(
                          totalScore: totalScore,
                          caseEntity: caseItem,
                        );

                        return PrimaryButton(
                          useWidget: true,
                          widget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  caseItem.title,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.mediumButtonText,
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                              ),
                              Visibility(
                                visible: !canOpen,
                                child: Row(
                                  children: [
                                    SizedBox(width: 5.w),
                                    Icon(
                                      Icons.lock,
                                      color: AppColors.scenderyColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          onPressed: () {
                            if (canOpen) {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.caseOverViewScreen,
                                arguments: {
                                  'caseId': caseItem.id,
                                  'difficulty': difficulty,
                                },
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'You need ${caseItem.unlockRole.requiredScore} points to unlock this case',
                                  ),
                                ),
                              );
                            }
                            ;
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
