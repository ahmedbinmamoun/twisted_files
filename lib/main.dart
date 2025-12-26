import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/navigation/app_routes.dart';
import 'package:twisted_files/data/data_source/local_case_data_source_impl.dart';
import 'package:twisted_files/data/repositories/case_repository_impl.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/features/case_overview_screen.dart/case_overView_screen.dart';
import 'package:twisted_files/features/cases_list_screen/cases_list_screen.dart';
import 'package:twisted_files/features/evidence_details_screen/evidence_details_scree.dart';
import 'package:twisted_files/features/evidence_list_screen/evidence_list_screen.dart';
import 'package:twisted_files/features/home_screen/home_screen.dart';
import 'package:twisted_files/features/levels_screen/case_levels_screen.dart';
import 'package:twisted_files/features/questions_screen/investigation_questions_screen.dart';

void main() {
  final localDataSource = LocalCaseDataSourceImpl();
  final CaseRepository repository = CaseRepositoryImpl(localDataSource);
  runApp( MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final CaseRepository repository;
  const MyApp({super.key, required this.repository});

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
            AppRoutes.caesesListScreen: (_) => CasesListScreen(repository: repository,),
            AppRoutes.caseOverViewScreen: (context){ 
              final caseId = ModalRoute.of(context)!.settings.arguments as String;
              return CaseOverviewScreen(caseId: caseId, repository: repository);
            } ,
            AppRoutes.evidenceListScreen: (_) => const EvidenceListScreen(),
            AppRoutes.evidenceDetailsScreen: (_) => const EvidenceDetailsScreen(),
            AppRoutes.investigationQuestionsScreen: (_) => const InvestigationQuestionsScreen(),
          },
        );
      },
    );
  }
}