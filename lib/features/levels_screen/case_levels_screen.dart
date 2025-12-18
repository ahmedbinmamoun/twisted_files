import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/navigation/app_routes.dart';
import 'package:twisted_files/features/common/widgets/primary_card.dart';

class CaseLevelsScreen extends StatelessWidget {
  const CaseLevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(AppAssests.backgroundImage,fit: BoxFit.fill,),
        Scaffold(
          backgroundColor: AppColors.transparentColor,
          body: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                SizedBox(height: 120.h,),
                Text('CASE LEVEL',style: AppStyles.logo,),
                SizedBox(height: 120.h,),
                PrimaryCard(
                  icon: AppAssests.oneStarIcon,
                   text: 'EASY CASES',
                   onPressed: (){
                    Navigator.pushNamed(context, AppRoutes.caesesListScreen);
                   },
                   ),
                SizedBox(height: 20.h,),
                PrimaryCard(icon: AppAssests.twoStarsIcon, text: 'MEDIUM CASES'),
                SizedBox(height: 20.h,),
                PrimaryCard(icon: AppAssests.threeStarsIcon, text: 'HARD CASES'),
              ],
            ),
          ),
          
        ),
      ],
    );
  }
}