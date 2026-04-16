import 'package:flutter_bloc/flutter_bloc.dart';
import 'questions_state.dart';

class QuestionsCubit extends Cubit<QuestionsState> {
  final int totalQuestions;

  QuestionsCubit({required this.totalQuestions})
      : super(const QuestionsAnswering(0));

  int get currentIndex => state is QuestionsAnswering
      ? (state as QuestionsAnswering).index
      : totalQuestions;

  void next() {
    if (isClosed) return;
    final next = currentIndex + 1;
    if (next >= totalQuestions) {
      emit(const QuestionsFinished());
    } else {
      emit(QuestionsAnswering(next));
    }
  }

  void reset() {
    if (isClosed) return;
    emit(const QuestionsAnswering(0));
  }
}