import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          backgroundColor: AppColors.transparentColor,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: BlocBuilder<InvestigationCubit, InvestigationState>(
              builder: (context, state) {
                if (state is InvestigationLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is InvestigationLoaded) {
                  final evidences = state.caseEntity.evidences;

                  return ListView.separated(
                    itemCount: evidences.length + 2,
                    separatorBuilder: (context, index) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: 30.h,
                            top: 80.h,
                          ),
                          child: Center(
                            child: Text(
                              'EVIDENCE',
                              style: AppStyles.logo,
                            ),
                          ),
                        );
                      }

                      if (index == evidences.length +1) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: 20.h, bottom: 20.h
                            ),
                            child: PrimaryButton(
                              text: 'START INVESTIGATION',
                             onPressed: (){
                              Navigator.pushNamed(context, AppRoutes.investigationQuestionsScreen, arguments: state.caseEntity);
                             }),
                            );
                      }
                  
                      final evidence = evidences[index - 1];
                      
                  
                      return PrimaryButton(
                        text: evidence.title,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.evidenceDetailsScreen,
                            arguments: {
                              'case' : state.caseEntity,
                              'evidence' : evidence,
                            }
                          );
                        },
                      );
                    },
                  );
                }

                if (state is InvestigationError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ],
    );
  }
}