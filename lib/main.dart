import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/navigation/app_routes.dart';
import 'package:twisted_files/data/data_source/local_case_data_source_impl.dart';
import 'package:twisted_files/data/data_source/local_score_data_source_impl.dart';
import 'package:twisted_files/data/repositories/case_repository_impl.dart';
import 'package:twisted_files/data/repositories/score_repository_impl.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';
import 'package:twisted_files/domain/use_cases/update_score_use_case.dart';
import 'package:twisted_files/features/about_screen/about_screen.dart';
import 'package:twisted_files/features/case_overview_screen.dart/case_overView_screen.dart';
import 'package:twisted_files/features/cases_list_screen/cases_list_screen.dart';
import 'package:twisted_files/features/evidence_details_screen/evidence_details_scree.dart';
import 'package:twisted_files/features/evidence_list_screen/evidence_list_screen.dart';
import 'package:twisted_files/features/home_screen/home_screen.dart';
import 'package:twisted_files/features/profile_screen/profile_screen.dart';
import 'package:twisted_files/features/questions_screen/investigation_questions_screen.dart';
import 'package:twisted_files/features/score/score_cubit/score_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  final localCaseDataSource = LocalCaseDataSourceImpl();
  final localScoreDataSource = LocalScoreDataSourceImpl(sharedPreferences);

  final CaseRepository caseRepository = CaseRepositoryImpl(localCaseDataSource);
  final ScoreRepository scoreRepository = ScoreRepositoryImpl(localScoreDataSource);

  final updateScoreUseCase = UpdateScoreUseCase(scoreRepository);

  runApp(MyApp(
    caseRepository: caseRepository,
    updateScoreUseCase: updateScoreUseCase,
    scoreRepository: scoreRepository,
  ));
}

class MyApp extends StatelessWidget {
  final CaseRepository caseRepository;
  final UpdateScoreUseCase updateScoreUseCase;
  final ScoreRepository scoreRepository;

  const MyApp({
    super.key,
    required this.caseRepository,
    required this.updateScoreUseCase,
    required this.scoreRepository
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ScoreCubit(useCase: updateScoreUseCase, repository: scoreRepository)),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
              progressIndicatorTheme: ProgressIndicatorThemeData(
                color: AppColors.scenderyColor,
                refreshBackgroundColor: AppColors.primaryColor,
              )
            ),
            home: HomeScreen(repository: caseRepository),
            // initialRoute: AppRoutes.homeScreen,
            routes: {
              // AppRoutes.homeScreen: (_) => HomeScreen(),
              AppRoutes.aboutScreen: (_) => AboutScreen(),
              AppRoutes.profileScreen: (_) => ProfileScreen(),
              // AppRoutes.levelsScreen: (_) => CaseLevelsScreen(),
              AppRoutes.caesesListScreen: (_) => CasesListScreen(repository: caseRepository),
              AppRoutes.caseOverViewScreen: (context) {
                final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                return CaseOverviewScreen(caseId: args['caseId'], repository: caseRepository, scoreRepository: scoreRepository,);
              },
              AppRoutes.evidenceListScreen: (_) => const EvidenceListScreen(),
              AppRoutes.evidenceDetailsScreen: (_) => const EvidenceDetailsScreen(),
              AppRoutes.investigationQuestionsScreen: (context) {
                final caseEntity = ModalRoute.of(context)!.settings.arguments as CaseEntity;
                // final caseEntity = args['case'];
                return InvestigationQuestionsScreen(
                  caseRepository: caseRepository,
                  caseEntity: caseEntity,
                  updateScoreUseCase: updateScoreUseCase,
                  scoreRepository: scoreRepository,
                );
              },
            },
          ),
        );
      },
    );
  }
}