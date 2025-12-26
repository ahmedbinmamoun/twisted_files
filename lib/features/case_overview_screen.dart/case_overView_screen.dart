import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/features/case_overview_screen.dart/case_overview_view.dart';
import 'package:twisted_files/features/investigation/cubit/investigation_cubit.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';

class CaseOverviewScreen extends StatelessWidget {
  final String caseId;
  final CaseRepository repository;

  const CaseOverviewScreen({
    super.key,
    required this.caseId,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InvestigationCubit(repository)..loadCase(caseId),
      child:  CaseOverviewView(),
    );
  }
}