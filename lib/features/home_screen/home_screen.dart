import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assest.dart';
import 'package:twisted_files/core/constants/app_colors.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/navigation/app_navigator.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';
import 'package:twisted_files/features/about_screen/about_screen.dart';
import 'package:twisted_files/features/common/widgets/primary_card.dart';
import 'package:twisted_files/features/levels_screen/case_levels_screen.dart';
import 'package:twisted_files/features/profile_screen/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final CaseRepository repository;
   HomeScreen({super.key, required this.repository});

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
                    AppNavigator.push(context, CaseLevelsScreen(repository: repository,));
                   },
                   ),
                SizedBox(height: 20.h,),
                PrimaryCard(icon: AppAssests.infoIcon, text: 'ABOUT',
                onPressed: (){
                  AppNavigator.push(context, AboutScreen());
                },),
                SizedBox(height: 20.h,),
                PrimaryCard(icon: AppAssests.oldDetectiveIcon, text: 'PROFILE',
                onPressed: (){
                  AppNavigator.push(context, ProfileScreen());
                },),
              ],
            ),
          ),
          
        ),
      ],
    );
  }
}