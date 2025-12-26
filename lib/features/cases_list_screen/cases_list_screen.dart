import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/navigation/app_routes.dart';
import 'package:twisted_files/features/cases_list_screen/cases_list_state.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';

class CasesListScreen extends StatelessWidget {
  final CaseRepository repository;

  const CasesListScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CasesListCubit(repository)..loadCases(),
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
                      separatorBuilder: (context, index) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 30.h, top: 80.h),
                            child: Center(
                              child: Text('Available Cases', style: AppStyles.logo),
                            ),
                          );
                        }

                        final caseItem = cases[index - 1];

                        return PrimaryButton(
                          text: '${caseItem.title}',
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.caseOverViewScreen,
                              arguments: caseItem.id,
                            );
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