import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twisted_files/data/data_source/local_case_data_source_impl.dart';
import 'package:twisted_files/data/data_source/local_score_data_source_impl.dart';
import 'package:twisted_files/data/repositories/case_repository_impl.dart';
import 'package:twisted_files/data/repositories/score_repository_impl.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/domain/repositories/score_repository.dart';
import 'package:twisted_files/domain/use_cases/get_profile_stats_use_case.dart';
import 'package:twisted_files/domain/use_cases/update_score_use_case.dart';
import 'package:twisted_files/features/score/score_viewmodel.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  // --- Data sources
  getIt.registerLazySingleton(() => LocalCaseDataSourceImpl(sharedPreferences));
  getIt.registerLazySingleton(() => LocalScoreDataSourceImpl(sharedPreferences));

  // --- Repositories
  getIt.registerLazySingleton<CaseRepository>(
      () => CaseRepositoryImpl(getIt<LocalCaseDataSourceImpl>()));
  getIt.registerLazySingleton<ScoreRepository>(
      () => ScoreRepositoryImpl(getIt<LocalScoreDataSourceImpl>()));

  // --- Use cases
  getIt.registerLazySingleton(() => UpdateScoreUseCase(getIt<ScoreRepository>()));
  getIt.registerLazySingleton(() => GetProfileStatsUseCase(getIt<ScoreRepository>()));

  // --- ViewModels
  // Register a single global ScoreViewModel so score is shared app-wide.
  getIt.registerLazySingleton<ScoreViewModel>(
    () => ScoreViewModel(
      getIt<UpdateScoreUseCase>(),
      getIt<ScoreRepository>(),
    ),
  );
}