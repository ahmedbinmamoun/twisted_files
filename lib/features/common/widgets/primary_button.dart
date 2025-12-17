import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';

class PrimaryButton extends StatelessWidget {
   PrimaryButton({super.key, required this.text, required this.onPressed});
   String text;
   VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 85.h,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20),
          
        ),
        child: Center(
             child: Text(text,style: AppStyles.mediumButtonText,),
         
        ),
      ),
    );
  }
}