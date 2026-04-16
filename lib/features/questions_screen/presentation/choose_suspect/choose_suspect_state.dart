import 'package:twisted_files/features/cases_list_screen/domain/entities/case_result_entity.dart';
import 'package:twisted_files/features/cases_list_screen/domain/entities/suspect_entity.dart';

abstract class ChooseSuspectState {
  const ChooseSuspectState();
}

/// الحالة الأولى — ينتظر المستخدم يختار
class ChooseSuspectIdle extends ChooseSuspectState {
  const ChooseSuspectIdle();
}

/// المستخدم اختار وبنحسب النتيجة
class ChooseSuspectLoading extends ChooseSuspectState {
  final SuspectEntity selectedSuspect;
  const ChooseSuspectLoading(this.selectedSuspect);
}

/// تمت العملية — جاهز لعرض النتيجة
class ChooseSuspectDone extends ChooseSuspectState {
  final CaseResultEntity result;
  final bool             isCorrect;
  const ChooseSuspectDone({required this.result, required this.isCorrect});
}

/// حصل error
class ChooseSuspectError extends ChooseSuspectState {
  final String message;
  const ChooseSuspectError(this.message);
}
