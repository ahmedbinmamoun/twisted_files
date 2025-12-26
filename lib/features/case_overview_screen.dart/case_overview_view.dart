import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_divider.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_header.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_page.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_section_title.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/evidence_list_screen/evidence_list_screen.dart';
import 'package:twisted_files/features/investigation/cubit/investigation_cubit.dart';
import 'package:twisted_files/features/investigation/cubit/investigation_state.dart';

class CaseOverviewView extends StatelessWidget {
  const CaseOverviewView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: BlocBuilder<InvestigationCubit, InvestigationState>(
            builder: (context, state) {
              if (state is InvestigationLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is InvestigationLoaded) {
                final caseEntity = state.caseEntity;

                return A4Page(
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
                        text: 'SHOW EVIDENCES',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => BlocProvider.value(value: context.read<InvestigationCubit>(),child: EvidenceListScreen(),))
                          );
                        },
                      ),
                    ],
                  ),
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
    );
  }
}