import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assets.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/di/injection_container.dart';
import 'package:twisted_files/features/cases_list_screen/domain/repositories/case_repository.dart';
import 'package:twisted_files/features/common/widgets/app_loading.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/evidence_details_screen/presentation/evidence_details_screen.dart';
import 'package:twisted_files/features/evidence_list_screen/presentation/cubit/evidence_list_cubit.dart';
import 'package:twisted_files/features/evidence_list_screen/presentation/cubit/evidence_list_state.dart';
import 'package:twisted_files/features/questions_screen/presentation/investigation_questions_screen.dart';
import 'package:twisted_files/features/score/presentation/score_view_model.dart';

class EvidenceListScreen extends StatelessWidget {
  final String caseId;
  const EvidenceListScreen({super.key, required this.caseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EvidenceListCubit(
        repository: getIt<CaseRepository>(),
        caseId: caseId,
      )..loadCase(),
      child: BlocBuilder<EvidenceListCubit, EvidenceListState>(
        builder: (ctx, state) {
          if (state is EvidenceListLoading) return const Scaffold(body: AppLoading());
          if (state is EvidenceListError)  return Center(child: Text(state.message));
          if (state is EvidenceListLoaded) {
            final evidences  = state.caseEntity.evidences;
            final suspects   = state.caseEntity.suspects;
            final totalItems = 1 + evidences.length + suspects.length + 1;
            return Stack(
              children: [
                Image.asset(AppAssets.backgroundImage, fit: BoxFit.fill, width: double.infinity, height: double.infinity),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: ListView.separated(
                      itemCount: totalItems,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (ctx2, i) {
                        if (i == 0) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 30.h, top: 80.h),
                            child: Center(child: Text('EVIDENCE', style: AppStyles.logo)),
                          );
                        }
                        if (i == totalItems - 1) {
                          return Padding(
                            padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                            child: PrimaryButton(
                              text: 'START INVESTIGATION',
                              onPressed: () {
                                getIt<ScoreViewModel>().startCaseSession(state.caseEntity.id).catchError((e) {
                                  if (kDebugMode) print('startCaseSession error: $e');
                                });
                                Navigator.push(ctx2, MaterialPageRoute(
                                  builder: (_) => InvestigationQuestionsScreen(caseEntity: state.caseEntity),
                                ));
                              },
                            ),
                          );
                        }
                        final ci = i - 1;
                        if (ci < evidences.length) {
                          final evidence = evidences[ci];
                          return PrimaryButton(
                            text: evidence.title,
                            onPressed: () => Navigator.push(ctx2, MaterialPageRoute(
                              builder: (_) => EvidenceDetailsScreen(
                                caseEntity: state.caseEntity,
                                isSuspect: false,
                                item: evidence,
                              ),
                            )),
                          );
                        } else {
                          final suspect = suspects[ci - evidences.length];
                          return PrimaryButton(
                            backgroundColor: AppColors.scenderyColor,
                            borderColor: AppColors.primaryColor,
                            text: suspect.name,
                            onPressed: () => Navigator.push(ctx2, MaterialPageRoute(
                              builder: (_) => EvidenceDetailsScreen(
                                caseEntity: state.caseEntity,
                                isSuspect: true,
                                item: suspect,
                              ),
                            )),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
