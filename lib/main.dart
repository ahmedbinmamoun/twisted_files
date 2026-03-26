import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/di/injection_container.dart';
import 'package:twisted_files/core/navigation/app_routes.dart';
import 'package:twisted_files/core/services/supabase_service.dart';
import 'package:twisted_files/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twisted_files/features/auth/presentation/cubit/auth_state.dart';
import 'package:twisted_files/features/case_overview_screen/presentation/case_overview_screen.dart';
import 'package:twisted_files/features/cases_list_screen/presentation/cases_list_screen.dart';
import 'package:twisted_files/features/common/widgets/app_loading.dart';
import 'package:twisted_files/features/home_screen/presentation/home_screen.dart';
import 'package:twisted_files/features/profile_screen/domain/use_cases/get_profile_stats_use_case.dart';
import 'package:twisted_files/features/profile_screen/presentation/cubit/profile_cubit.dart';
import 'package:twisted_files/features/profile_screen/presentation/profile_screen.dart';
import 'package:twisted_files/features/rank_screen/domain/use_cases/get_user_rank_use_case.dart';
import 'package:twisted_files/features/score/domain/repositories/score_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Supabase (must happen before DI)
  await SupabaseService.initialize();

  // 2. Wire all dependencies
  await configureDependencies();

  await MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (_, __) {
        return MultiBlocProvider(
          providers: [
            // AuthCubit — global singleton, kicks off anonymous session on start
            BlocProvider<AuthCubit>(
              create: (_) => getIt<AuthCubit>()..initSession(),
            ),
            // ProfileCubit — global so ProfileScreen works from any nav route
            BlocProvider(
              create: (_) => ProfileCubit(
                scoreRepository: getIt<ScoreRepository>(),
                getStats: getIt<GetProfileStatsUseCase>(), 
                getUserRank: getIt<GetUserRankUseCase>(),
              ),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primaryColor,
              ),
              progressIndicatorTheme: ProgressIndicatorThemeData(
                color: AppColors.scenderyColor,
                refreshBackgroundColor: AppColors.primaryColor,
              ),
            ),
            // Show a loading indicator while the anonymous session initialises,
            // then go straight to HomeScreen — no login screen needed.
            home: BlocBuilder<AuthCubit, AuthState>(
              builder: (_, state) {
                if (state is AuthInitial || state is AuthLoading) {
                  return const Scaffold(
                    body: AppLoading(),
                  );
                }
                return const HomeScreen();
              },
            ),
            routes: {
              AppRoutes.profileScreen: (_) => const ProfileScreen(),
              AppRoutes.casesListScreen: (_) => const CasesListScreen(),
              AppRoutes.caseOverViewScreen: (ctx) {
                final args = ModalRoute.of(ctx)?.settings.arguments; // ← ? مش !

                // لو arguments جاء Map
                if (args is Map<String, dynamic>) {
                  final caseId = args['caseId'] as String?;
                  if (caseId != null && caseId.isNotEmpty) {
                    return CaseOverviewScreen(caseId: caseId);
                  }
                }

                // لو arguments جاء String مباشرة
                if (args is String && args.isNotEmpty) {
                  return CaseOverviewScreen(caseId: args);
                }

                // fallback
                return const Scaffold(
                  body: Center(child: Text('Case not found')),
                );
              },
            },
          ),
        );
      },
    );
  }
}
