import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';

class PrimaryButton extends StatelessWidget {
   PrimaryButton({super.key, required this.text, required this.onPressed, this.backgroundColor, this.borderColor});
   String text;
   VoidCallback? onPressed;
   Color? backgroundColor;
   Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
        width: double.infinity,
        // height: 80.h,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor ?? AppColors.primaryColor,
            width: 3.w
          )
          
        ),
        child: Center(
             child: Text(text,
             maxLines: null,
             softWrap: true,
             style: AppStyles.mediumButtonText.copyWith(
              color: borderColor ?? AppColors.scenderyColor
             ),textAlign: TextAlign.center,),
         
        ),
      ),
    );
  }
}