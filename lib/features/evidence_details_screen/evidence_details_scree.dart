import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_page.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_header.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_section_title.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_divider.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/features/notes/notes_fab.dart';

class EvidenceDetailsScreen extends StatelessWidget {
  const EvidenceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final caseEntity = args['case'];
    final evidence = args['evidence'];

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

                A4SectionTitle(evidence.title),

                Text(evidence.content, style: AppStyles.mediumBody),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
