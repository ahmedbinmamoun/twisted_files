import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twisted_files/core/constants/app_assets.dart';
import 'package:twisted_files/core/constants/app_style.dart';
import 'package:twisted_files/core/di/injection_container.dart';
import 'package:twisted_files/features/case_overview_screen/domain/use_cases/get_case_use_case.dart';
import 'package:twisted_files/features/case_overview_screen/domain/use_cases/reset_case_use_case.dart';
import 'package:twisted_files/features/case_overview_screen/presentation/cubit/case_overview_cubit.dart';
import 'package:twisted_files/features/case_overview_screen/presentation/cubit/case_overview_state.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_divider.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_header.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_page.dart';
import 'package:twisted_files/features/common/widgets/a4/a4_section_title.dart';
import 'package:twisted_files/features/common/widgets/app_dialog.dart';
import 'package:twisted_files/features/common/widgets/app_loading.dart';
import 'package:twisted_files/features/common/widgets/primary_button.dart';
import 'package:twisted_files/features/evidence_list_screen/presentation/evidence_list_screen.dart';
import 'package:twisted_files/features/notes/presentation/notes_fab.dart';
import 'package:twisted_files/features/score/domain/repositories/score_repository.dart';

class CaseOverviewScreen extends StatelessWidget {
  final String caseId;
  const CaseOverviewScreen({super.key, required this.caseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CaseOverviewCubit(
        getCase: getIt<GetCaseUseCase>(),
        resetCase: getIt<ResetCaseUseCase>(),
        scoreRepository: getIt<ScoreRepository>(),
        caseId: caseId,
      )..load(),
      child: BlocBuilder<CaseOverviewCubit, CaseOverviewState>(
        builder: (ctx, state) {
          // ── Loading ─────────────────────────────────────────────────────
          if (state.isLoading) {
            return const Scaffold(body: AppLoading());
          }

          // ── Error ────────────────────────────────────────────────────────
          if (state.error != null) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading case',
                        style: Theme.of(ctx).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => ctx.read<CaseOverviewCubit>().load(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // ── Data not yet available (extra safety) ────────────────────────
          if (state.caseEntity == null) {
            return const Scaffold(body: AppLoading());
          }

          // ── Success ──────────────────────────────────────────────────────
          final c = state.caseEntity!;
          return Scaffold(
            floatingActionButton: NotesFab(caseId: c.id),
            body: Stack(
              children: [
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: A4Page(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          A4Header(
                            caseNumber: c.caseNumber,
                            date: c.date,
                            location: c.location,
                            title: c.title,
                          ),
                          const A4Divider(),
                          const A4SectionTitle('Case Summary'),
                          Text(c.summary, style: AppStyles.mediumBody),
                          SizedBox(height: 32.h),
                          PrimaryButton(
                            text: state.isCompleted
                                ? 'Re-Investigation'
                                : 'Show Evidences',
                            onPressed: () {
                              if (!state.isCompleted) {
                                Navigator.push(
                                  ctx,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EvidenceListScreen(caseId: c.id),
                                  ),
                                );
                              } else {
                                final cubit = ctx.read<CaseOverviewCubit>();

                                AppDialog.show(
                                  ctx, 
                                  imagePath: AppAssets.caseClosedSticker,
                                  title: 'Re-Investigation',
                                  summary: 'This will reset your score.',
                                  barrierDismissible: false,
                                  actions: [
                                    AppDialogAction(
                                      label: 'Cancel',
                                      onPressed: () => Navigator.pop(ctx),
                                    ),
                                    AppDialogAction(
                                      label: 'Confirm',
                                      isPrimary: true,
                                      onPressed: () async {
                                        await cubit
                                            .resetCase(); 
                                        Navigator.pop(ctx);
                                      },
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (state.isCompleted)
                  Center(
                    child: Image.asset(
                      AppAssets.caseClosedSticker,
                      width: 300.w,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

}
