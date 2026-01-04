import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/navigation/app_routes.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/investigation/cubit/investigation_cubit.dart';
import 'package:twisted_files/features/investigation/cubit/investigation_state.dart';


class EvidenceListScreen extends StatelessWidget {
  const EvidenceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AppAssests.backgroundImage,
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: BlocBuilder<InvestigationCubit, InvestigationState>(
              builder: (context, state) {
                if (state is InvestigationLoaded) {
                  final evidences = state.caseEntity.evidences;
                  final suspects = state.caseEntity.suspects;

                  final totalItems = 1 + evidences.length + suspects.length + 1;
                  return ListView.separated(
                    itemCount: totalItems,
                    separatorBuilder: (context, index) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 30.h, top: 80.h),
                          child: Center(
                            child: Text(
                              'EVIDENCE',
                              style: AppStyles.logo,
                            ),
                          ),
                        );
                      }

                      if (index == totalItems - 1) {
                        return Padding(
                          padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                          child: PrimaryButton(
                            text: 'START INVESTIGATION',
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.investigationQuestionsScreen,
                                arguments: state.caseEntity,
                              );
                            },
                          ),
                        );
                      }

                      final contentIndex = index - 1; 
                      if (contentIndex < evidences.length) {
                        final evidence = evidences[contentIndex];
                        return PrimaryButton(
                          text: evidence.title,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.evidenceDetailsScreen,
                              arguments: {
                                'case': state.caseEntity,
                                'isSuspect': false,
                                'evidence': evidence,
                              },
                            );
                          },
                        );
                      } else {
                        final suspectIndex = contentIndex - evidences.length;
                        final suspect = suspects[suspectIndex];
                        return PrimaryButton(
                          backgroundColor: AppColors.scenderyColor,
                          borderColor: AppColors.primaryColor,
                          text: suspect.name,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.evidenceDetailsScreen,
                              arguments: {
                                'case': state.caseEntity,
                                'isSuspect': true,
                                'suspect': suspect,
                              },
                            );
                          },
                        );
                      }
                    },
                  );
                }

                if (state is InvestigationError) {
                  return Center(child: Text(state.message));
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ],
    );
  }
}
