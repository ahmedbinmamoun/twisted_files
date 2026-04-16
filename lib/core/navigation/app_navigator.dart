import 'package:flutter/material.dart';
import 'page_transitions.dart';

class AppNavigator {
  static Future push(BuildContext context, Widget page) {
    return Navigator.of(context).push(PageTransitions.fadeSlide(page));
  }

  static Future pushReplace(BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement(PageTransitions.fadeSlide(page));
  }

  static Future pushAndClear(BuildContext context, Widget page) {
    return Navigator.of(context).pushAndRemoveUntil(
      PageTransitions.fadeSlide(page),
      (route) => false,
    );
  }

  static void pop(BuildContext context) => Navigator.of(context).pop();
}
