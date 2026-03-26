import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionsCubit extends Cubit<int> {
  QuestionsCubit() : super(0);
  void next()  => emit(state + 1);
  void reset() => emit(0);
}
