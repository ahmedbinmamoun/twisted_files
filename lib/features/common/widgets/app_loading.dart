import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:twisted_files/core/constants/app_assets.dart';
import 'package:twisted_files/core/constants/app_colors.dart';


class AppLoading extends StatelessWidget {
  final bool   fullScreen; 
  final double size;      
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
