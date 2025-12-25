import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/navigation/app_routes.dart';
import 'package:twisted_files/features/case_overview_screen.dart/case_overView_screen.dart';
import 'package:twisted_files/features/cases_list_screen/cases_list_screen.dart';
import 'package:twisted_files/features/evidence_details_screen/evidence_details_scree.dart';
import 'package:twisted_files/features/evidence_list_screen/evidence_list_screen.dart';
import 'package:twisted_files/features/home_screen/home_screen.dart';
import 'package:twisted_files/features/levels_screen/case_levels_screen.dart';
import 'package:twisted_files/features/questions_screen/investigation_questions_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.homeScreen,
          routes: {
            AppRoutes.homeScreen: (_) => HomeScreen(),
            AppRoutes.levelsScreen: (_) => CaseLevelsScreen(),
            AppRoutes.caesesListScreen: (_) => CasesListScreen(),
            AppRoutes.caseOverViewScreen: (_) => const CaseOverviewScreen(),
            AppRoutes.evidenceListScreen: (_) => const EvidenceListScreen(),
            AppRoutes.evidenceDetailsScreen: (_) => const EvidenceDetailsScreen(),
            AppRoutes.investigationQuestionsScreen: (_) => const InvestigationQuestionsScreen(),
          },
        );
      },
    );
  }
}