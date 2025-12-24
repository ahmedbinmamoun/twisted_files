import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/data/data_source/local_case_data_source_impl.dart';
import 'package:twisted_files/data/repositories/case_repository_impl.dart';
import 'package:twisted_files/features/case_overview_screen.dart/case_overview_view.dart';
import 'package:twisted_files/features/investigation/cubit/investigation_cubit.dart';

class CaseOverviewScreen extends StatelessWidget {
  const CaseOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final localDataSource = LocalCaseDataSourceImpl();
        final repository = CaseRepositoryImpl(localDataSource);
        return InvestigationCubit(repository)..loadCase('case-002');
      },
      child:  CaseOverviewView(),
    );
  }
}