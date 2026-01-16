import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/evidence_list_screen/cubit/evidence_list_state.dart';
import 'evidence_list_view_model.dart';
import 'package:twisted_files/config/di/config_di.dart';
import 'package:twisted_files/features/evidence_details_screen/evidence_details_scree.dart';
import 'package:twisted_files/features/questions_screen/investigation_questions_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:twisted_files/domain/use_cases/update_score_use_case.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/features/score/score_viewmodel.dart';

class EvidenceListScreen extends StatelessWidget {
  final String caseId;

  const EvidenceListScreen({super.key, required this.caseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EvidenceListViewModel(
        caseId: caseId,
        caseRepository: getIt(),
      )..loadCase(),
      child: BlocBuilder<EvidenceListViewModel, EvidenceListState>(
        builder: (context, state) {
          if (state is EvidenceListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EvidenceListError) {
            return Center(child: Text(state.message));
          }

          if (state is EvidenceListLoaded) {
            final evidences = state.caseEntity.evidences;
            final suspects = state.caseEntity.suspects;
            final totalItems = 1 + evidences.length + suspects.length + 1;

            return Stack(
              children: [
                Image.asset(AppAssests.backgroundImage,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: ListView.separated(
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
                                  final scoreVm = getIt<ScoreViewModel>();
                                  // fire-and-forget so navigation is not blocked if startCaseSession
                                  // experiences a delay or error.
                                  scoreVm.startCaseSession(state.caseEntity.id).catchError((e, st) {
                                    // ignore here, investigation screen also attempts to start session
                                    // but log in debug mode.
                                    if (kDebugMode) {
                                      print('startCaseSession error: $e\n$st');
                                    }
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => InvestigationQuestionsScreen(
                                        caseEntity: state.caseEntity,
                                        updateScoreUseCase: getIt<UpdateScoreUseCase>(),
                                        scoreRepository: getIt<ScoreRepository>(),
                                        caseRepository: getIt<CaseRepository>(),
                                      ),
                                    ),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const EvidenceDetailsScreen(),
                                    settings: RouteSettings(
                                      arguments: {
                                        'case': state.caseEntity,
                                        'isSuspect': false,
                                        'evidence': evidence,
                                      },
                                    ),
                                  ),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const EvidenceDetailsScreen(),
                                    settings: RouteSettings(
                                      arguments: {
                                        'case': state.caseEntity,
                                        'isSuspect': true,
                                        'suspect': suspect,
                                      },
                                    ),
                                  ),
                                );
                            },
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