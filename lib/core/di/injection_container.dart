import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Core
import 'package:twisted_files/core/services/supabase_service.dart';

// Auth Feature
import 'package:twisted_files/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:twisted_files/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:twisted_files/features/auth/domain/repositories/auth_repository.dart';
import 'package:twisted_files/features/auth/domain/use_cases/get_current_profile_use_case.dart';
import 'package:twisted_files/features/auth/domain/use_cases/sign_in_anonymously_use_case.dart';
import 'package:twisted_files/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';
import 'package:twisted_files/features/auth/domain/use_cases/update_nickname_use_case.dart';
import 'package:twisted_files/features/auth/presentation/cubit/auth_cubit.dart';

// Cases Feature
import 'package:twisted_files/features/cases_list_screen/data/data_sources/case_remote_data_source.dart';
import 'package:twisted_files/features/cases_list_screen/data/repositories/case_repository_supabase_impl.dart';
import 'package:twisted_files/features/cases_list_screen/domain/repositories/case_repository.dart';
import 'package:twisted_files/features/cases_list_screen/domain/use_cases/can_open_case_use_case.dart';
import 'package:twisted_files/features/cases_list_screen/domain/use_cases/get_cases_by_difficulty_use_case.dart';

// Case Overview
import 'package:twisted_files/features/case_overview_screen/domain/use_cases/get_case_use_case.dart';
import 'package:twisted_files/features/case_overview_screen/domain/use_cases/reset_case_use_case.dart';
import 'package:twisted_files/features/rank_screen/data/data_sources/rank_remote_data_source.dart';
import 'package:twisted_files/features/rank_screen/data/repositories/rank_repository_impl.dart';
import 'package:twisted_files/features/rank_screen/domain/repositories/rank_repository.dart';
import 'package:twisted_files/features/rank_screen/domain/use_cases/get_leaderboard_use_case.dart';
import 'package:twisted_files/features/rank_screen/domain/use_cases/get_user_rank_use_case.dart';

// Score Feature
import 'package:twisted_files/features/score/data/data_sources/score_remote_data_source.dart';
import 'package:twisted_files/features/score/data/repositories/score_repository_supabase_impl.dart';
import 'package:twisted_files/features/score/domain/repositories/score_repository.dart';
import 'package:twisted_files/features/score/domain/use_cases/get_score_use_case.dart';
import 'package:twisted_files/features/score/domain/use_cases/update_score_use_case.dart';
import 'package:twisted_files/features/score/presentation/score_view_model.dart';

// Profile Feature
import 'package:twisted_files/features/profile_screen/domain/use_cases/get_profile_stats_use_case.dart';
import 'package:twisted_files/features/profile_screen/presentation/cubit/profile_cubit.dart';

final GetIt getIt = GetIt.instance;

/// Single entry-point for all DI registrations.
/// DIP: Every feature depends on abstractions, not on concrete implementations.
/// OCP: Adding a new feature = adding new registrations here only.
Future<void> configureDependencies() async {
  // ── Infrastructure ──────────────────────────────────────────────────────
  // Supabase.initialize() must be called in main() BEFORE this.
  getIt.registerLazySingleton(() => SupabaseService.client);
  getIt.registerLazySingleton(() => GoogleSignIn(scopes: ['email', 'profile']));

  // ── Auth Feature ────────────────────────────────────────────────────────
  getIt.registerLazySingleton(
    () => AuthRemoteDataSource(client: getIt(), googleSignIn: getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => GetCurrentProfileUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => SignInAnonymouslyUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => SignInWithGoogleUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => UpdateNicknameUseCase(getIt<AuthRepository>()),
  );

  // Singleton AuthCubit — one session throughout the app
  getIt.registerLazySingleton(
    () => AuthCubit(
      getProfile: getIt<GetCurrentProfileUseCase>(),
      signInAnon: getIt<SignInAnonymouslyUseCase>(),
      signInGoogle: getIt<SignInWithGoogleUseCase>(),
      updateNickname: getIt<UpdateNicknameUseCase>(),
    ),
  );

  // ── Score Feature ───────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => ScoreRemoteDataSource(client: getIt()));
  getIt.registerLazySingleton<ScoreRepository>(
    () => ScoreRepositorySupabaseImpl(getIt<ScoreRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => UpdateScoreUseCase(getIt<ScoreRepository>()),
  );
  getIt.registerLazySingleton(() => GetScoreUseCase(getIt<ScoreRepository>()));
  // Singleton ScoreViewModel — shared score state across all screens
  getIt.registerLazySingleton<ScoreViewModel>(
    () => ScoreViewModel(getIt<UpdateScoreUseCase>(), getIt<ScoreRepository>()),
  );

  // Rank Feature
  getIt.registerLazySingleton(() => RankRemoteDataSource(client: getIt()));
  getIt.registerLazySingleton<RankRepository>(
    () => RankRepositoryImpl(getIt<RankRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => GetLeaderboardUseCase(getIt<RankRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetUserRankUseCase(getIt<RankRepository>()),
  );

  // ── Cases Feature ───────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => CaseRemoteDataSource(client: getIt()));
  getIt.registerLazySingleton<CaseRepository>(
    () => CaseRepositorySupabaseImpl(getIt<CaseRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => GetCasesByDifficultyUseCase(getIt<CaseRepository>()),
  );
  getIt.registerLazySingleton(() => const CanOpenCaseUseCase());
  getIt.registerLazySingleton(() => GetCaseUseCase(getIt<CaseRepository>()));

  // ── Case Overview Feature ───────────────────────────────────────────────
  getIt.registerLazySingleton(() => ResetCaseUseCase(getIt<ScoreRepository>()));

  // ── Profile Feature ─────────────────────────────────────────────────────
  getIt.registerLazySingleton(
    () => GetProfileStatsUseCase(getIt<ScoreRepository>()),
  );
  // Factory: new instance every time ProfileScreen opens
  getIt.registerFactory(
    () => ProfileCubit(
      scoreRepository: getIt<ScoreRepository>(),
      getStats: getIt<GetProfileStatsUseCase>(),
      getUserRank: getIt<GetUserRankUseCase>(),
    ),
  );
}
