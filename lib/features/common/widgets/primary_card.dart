import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';

class PrimaryCard extends StatelessWidget {
   PrimaryCard({super.key, required this.icon, required this.text,this.onPressed});

    VoidCallback? onPressed;
    String icon;
    String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 170.h,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(25),
          
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20.h,),
              Image.asset(icon,width: 50.w,height: 50.h,),
              SizedBox(height: 15.h,),
              Text(text,style: AppStyles.largeButtonText,),
            ],
          ),
        ),
      ),
    );
  }
}