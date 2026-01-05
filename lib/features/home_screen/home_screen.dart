import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/navigation/app_routes.dart';
import 'package:twisted_files/features/common/widgets/primary_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                Text('Twisted Files',style: AppStyles.logo,),
                SizedBox(height: 120.h,),
                PrimaryCard(
                  icon: AppAssests.folderIcon,
                   text: 'CASES FILES',
                   onPressed: () {
                     Navigator.pushNamed(context, AppRoutes.levelsScreen);
                   },
                   ),
                SizedBox(height: 20.h,),
                PrimaryCard(icon: AppAssests.infoIcon, text: 'ABOUT',onPressed: (){
                  Navigator.pushNamed(context, AppRoutes.aboutScreen);
                },),
                SizedBox(height: 20.h,),
                PrimaryCard(icon: AppAssests.oldDetectiveIcon, text: 'PROFILE',onPressed: (){
                  Navigator.pushNamed(context, AppRoutes.profileScreen);
                },),
              ],
            ),
          ),
          
        ),
      ],
    );
  }
}