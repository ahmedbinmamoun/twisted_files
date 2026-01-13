import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_divider.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_header.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_page.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_section_title.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/evidence_list_screen/evidence_list_screen.dart';
import 'package:twisted_files/features/investigation/cubit/investigation_cubit.dart';
import 'package:twisted_files/features/investigation/cubit/investigation_state.dart';
import 'package:twisted_files/features/notes/notes_fab.dart';
import 'package:twisted_files/features/score/score_cubit/score_cubit.dart';


class CaseOverviewView extends StatelessWidget {
  // String difficulty;
   CaseOverviewView({super.key,
    // required this.difficulty
   });

  void _startCase(BuildContext context, CaseEntity caseEntity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<InvestigationCubit>(),
          child: const EvidenceListScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvestigationCubit, InvestigationState>(
      builder: (context, state) {
        if (state is InvestigationLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is InvestigationLoaded) {
          final caseEntity = state.caseEntity;

          final scoreCubit = context.watch<ScoreCubit>();
          final isCompleted = scoreCubit.state.isCaseCompleted;
          final oldScore = context.read<ScoreCubit>().state.previousCaseScore;

          return Scaffold(
            floatingActionButton: NotesFab(caseId: caseEntity.id),
            body: Stack(
              children: [
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: A4Page(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          A4Header(
                            caseNumber: caseEntity.caseNumber,
                            date: caseEntity.date,
                            location: caseEntity.location,
                            title: caseEntity.title,
                          ),
                
                          const A4Divider(),
                          const A4SectionTitle('Case Summary'),
                
                          Text(
                            caseEntity.summary,
                            style: AppStyles.mediumBody,
                          ),
                
                          SizedBox(height: 32.h),
                
                          PrimaryButton(
                            text: isCompleted
                                ? 'Re-Investigation'
                                : 'Show Evidences',
                            onPressed: () {
                              if (!isCompleted) {
                                _startCase(context, caseEntity);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Re-Investigation'),
                                    content: Text(
                                      'Previous score: $oldScore\n\n'
                                      'This will reset this case score.',
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () =>
                                            Navigator.pop(context),
                                      ),
                                      TextButton(
                                        child: const Text('Confirm'),
                                        onPressed: () async {
                                          await context
                                              .read<ScoreCubit>()
                                              .resetCase(caseEntity);
                
                                          Navigator.pop(context);
                                          _startCase(context, caseEntity);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isCompleted,
                  child: Center(
                    child: Image.asset(AppAssests.caseClosedStiker),
                  ),
                )
              ],
            ),
          );
        }

        if (state is InvestigationError) {
          return Scaffold(
            body: Center(child: Text(state.message)),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}