import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/config/di/config_di.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/navigation/app_routes.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';
import 'package:twisted_files/domain/use_cases/get_profile_stats_use_case.dart';
import 'package:twisted_files/features/case_overview_screen.dart/case_overView_screen.dart';
import 'package:twisted_files/features/cases_list_screen/cases_list_screen.dart';
import 'package:twisted_files/features/home_screen/home_screen.dart';
import 'package:twisted_files/features/profile_screen/cubit/profile_cubit.dart';
import 'package:twisted_files/features/profile_screen/profile_screen.dart';
// ScoreCubit removed; using global ScoreViewModel via DI

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ProfileCubit(
                scoreRepository: getIt<ScoreRepository>(),
                getCaseStats: getIt<GetProfileStatsUseCase>(),
              ),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
              progressIndicatorTheme: ProgressIndicatorThemeData(
                color: AppColors.scenderyColor,
                refreshBackgroundColor: AppColors.primaryColor,
              ),
            ),
            home: HomeScreen(repository: getIt<CaseRepository>()),
            routes: {
              AppRoutes.profileScreen: (_) => const ProfileScreen(),
              AppRoutes.caesesListScreen: (_) => CasesListScreen(repository: getIt<CaseRepository>()),
              AppRoutes.caseOverViewScreen: (context) {
                final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                return CaseOverviewScreen(caseId: args['caseId']);
              },
            },
          ),
        );
      },
    );
  }
  
}