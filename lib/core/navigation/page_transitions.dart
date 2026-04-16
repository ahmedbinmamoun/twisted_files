import 'package:flutter/material.dart';

class PageTransitions {
  static PageRoute fadeSlide(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        final fadeAnimation = Tween<double>(begin: 0, end: 1).animate(animation);
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
    );
  }

  static PageRoute slideFromRight(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final slide = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation);
        return SlideTransition(position: slide, child: child);
      },
    );
  }
}
