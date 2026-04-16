import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:twisted_files/core/constants/app_assets.dart';
import 'package:twisted_files/core/constants/app_colors.dart';

/// Widget الـ loading الموحد للتطبيق كله
///
/// الاستخدام:
/// ```dart
/// // بدل CircularProgressIndicator()
/// const AppLoading()
///
/// // مع خلفية كاملة (زي Scaffold)
/// const AppLoading(fullScreen: true)
///
/// // حجم مخصص
/// AppLoading(size: 150)
/// ```
class AppLoading extends StatelessWidget {
  final bool   fullScreen; // true = يملأ الشاشة كاملة
  final double size;        // حجم الـ lottie
  final Color? backgroundColor;

  const AppLoading({
    super.key,
    this.fullScreen     = false,
    this.size           = 120,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final lottie = Lottie.asset(
      AppAssets.detectiveWalkLottie,
      width:    size,
      height:   size,
      fit:      BoxFit.contain,
      repeat:   true,
    );

    if (fullScreen) {
      return Scaffold(
        backgroundColor: backgroundColor ?? AppColors.offWhiteColor,
        body: Center(child: lottie),
      );
    }

    return Center(child: lottie);
  }
}
