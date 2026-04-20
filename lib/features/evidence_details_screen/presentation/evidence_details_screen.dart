import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/case_entity.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_divider.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_header.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_page.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_section_title.dart';
import 'package:twisted_files/features/notes/presentation/notes_fab.dart';

/// SRP: Only displays details for a single evidence or suspect item.
class EvidenceDetailsScreen extends StatelessWidget {
  final CaseEntity caseEntity;
  final bool isSuspect;
  final dynamic item;

  const EvidenceDetailsScreen({
    super.key,
    required this.caseEntity,
    required this.isSuspect,
    required this.item,
  });

  String get _title   => isSuspect ? (item?.name ?? '')  : (item?.title ?? '');
  String get _content => isSuspect ? (item?.description ?? '') : (item?.content ?? '');

  @override
  Widget build(BuildContext context) {
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
                A4SectionTitle(_title),
                Text(_content, style: AppStyles.mediumBody),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
