import 'package:twisted_files/features/cases_list_screen/domain/entities/case_result_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/suspect_entity.dart';

abstract class ChooseSuspectState {
  const ChooseSuspectState();
}

class ChooseSuspectIdle extends ChooseSuspectState {
  const ChooseSuspectIdle();
}

class ChooseSuspectLoading extends ChooseSuspectState {
  final SuspectEntity selectedSuspect;
  const ChooseSuspectLoading(this.selectedSuspect);
}

class ChooseSuspectDone extends ChooseSuspectState {
  final CaseResultEntity result;
  final bool             isCorrect;
  const ChooseSuspectDone({required this.result, required this.isCorrect});
}

class ChooseSuspectError extends ChooseSuspectState {
  final String message;
  const ChooseSuspectError(this.message);
}
