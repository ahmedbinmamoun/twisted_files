import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_page.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_header.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_section_title.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_divider.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/features/notes/notes_fab.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'evidence_details_view_model.dart';

class EvidenceDetailsScreen extends StatelessWidget {
  const EvidenceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final CaseEntity caseEntity = args['case'];
    final bool isSuspect = args['isSuspect'] == true;
    final dynamic item = isSuspect ? args['suspect'] : args['evidence'];

    return BlocProvider(
      create: (_) => EvidenceDetailsViewModel(
        caseEntity: caseEntity,
        item: item,
        isSuspect: isSuspect,
      ),
      child: const _EvidenceDetailsView(),
    );
  }
}

class _EvidenceDetailsView extends StatelessWidget {
  const _EvidenceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<EvidenceDetailsViewModel>();
    final caseEntity = viewModel.caseEntity;

    return Scaffold(
      floatingActionButton: NotesFab(caseId: caseEntity.id),
      body: SafeArea(
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

                A4SectionTitle(viewModel.title),

                Text(viewModel.content, style: AppStyles.mediumBody),
              ],
            ),
          ),
        ),
      ),
    );
  }
}