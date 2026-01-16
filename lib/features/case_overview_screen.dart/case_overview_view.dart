import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/features/case_overview_screen.dart/cubit/case_overview_state.dart';
import 'package:twisted_files/features/case_overview_screen.dart/cubit/case_overview_view_model.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_divider.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_header.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_page.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_section_title.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/evidence_list_screen/evidence_list_screen.dart';
import 'package:twisted_files/features/notes/notes_fab.dart';

class CaseOverviewView extends StatelessWidget {
  const CaseOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaseOverviewViewModel, CaseOverviewState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.error != null) {
          return Scaffold(
            body: Center(child: Text(state.error!)),
          );
        }

        final caseEntity = state.caseEntity!;

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
                        Text(caseEntity.summary, style: AppStyles.mediumBody),
                        SizedBox(height: 32.h),
                        PrimaryButton(
                          text: state.isCompleted
                              ? 'Re-Investigation'
                              : 'Show Evidences',
                          onPressed: () {
                            if (!state.isCompleted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>  EvidenceListScreen(caseId: caseEntity.id,),
                                ),
                              );
                            } else {
                              _showResetDialog(context, state.previousScore);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (state.isCompleted)
                Center(
                  child: Image.asset(AppAssests.caseClosedStiker,width: 300.w,),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showResetDialog(BuildContext context, int score) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Re-Investigation'),
        content: Text(
          'Previous score: $score\n\nThis will reset this case score.',
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () async {
              await context.read<CaseOverviewViewModel>().resetCase();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}