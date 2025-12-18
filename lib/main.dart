import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/navigation/app_routes.dart';
import 'package:twisted_files/features/cases_list_screen/cases_list_screen.dart';
import 'package:twisted_files/features/home_screen/home_screen.dart';
import 'package:twisted_files/features/levels_screen/case_levels_screen.dart';

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
          initialRoute: AppRoutes.HomeScreen,
        routes: {
          AppRoutes.HomeScreen : (context) => HomeScreen(),
          AppRoutes.levelsScreen : (context) => CaseLevelsScreen(),
          AppRoutes.caesesListScreen : (context) => CasesListScreen(),
        },
        );
      },
    );
  }
}