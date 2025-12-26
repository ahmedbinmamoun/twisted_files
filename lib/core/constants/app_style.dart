import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppStyles {
  static TextStyle largeButtonText = GoogleFonts.cairo(
    fontSize: 30.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.scenderyColor,
  );
  static TextStyle mediumButtonText = GoogleFonts.cairo(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.scenderyColor,
  );
  static TextStyle logo = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 40.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.blackColor,
  );
  static TextStyle largeTitle = GoogleFonts.cairo(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.blackColor,
  );
  static TextStyle mediumTitle = GoogleFonts.cairo(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
  );
  static TextStyle largeBody = GoogleFonts.cairo(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.blackColor,
    height: 1.4,
  );
  static TextStyle mediumBody = GoogleFonts.cairo(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.lightBlack,
  );
  static TextStyle light11red = GoogleFonts.cairo(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.redColor,
    letterSpacing: 2,
  );
  
}
