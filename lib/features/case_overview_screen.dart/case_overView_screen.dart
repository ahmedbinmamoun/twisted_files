import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/features/case_overview_screen.dart/case.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_divider.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_header.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_page.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_section_title.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';

class CaseOverviewScreen extends StatelessWidget {
   CaseOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: A4Page(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const A4Header(
                  title: Case.title,
                  caseNumber: Case.number,
                  date: Case.date,
                  location: Case.location,
                ),

                const A4Divider(),

                const A4SectionTitle("Case Summary"),

                Text(
                  Case.summary,
                ),

                const A4SectionTitle("Known Facts"),

                Text(
                  "- ${Case.fact1}\n"
                  "- ${Case.fact2}\n"
                  "- ${Case.fact3}\n"
                  "- ${Case.fact4}\n"
                  "- ${Case.fact5}\n"
                  
                ),
                SizedBox(height: 20.h,),
                PrimaryButton(text: 'Start Investigation', onPressed: (){}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}