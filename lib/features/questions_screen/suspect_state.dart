import 'package:flutter_bloc/flutter_bloc.dart';

class SuspectState {
  final String? selectedId;
  final String? correctId;

  SuspectState({this.selectedId, this.correctId});

  SuspectState copyWith({String? selectedId, String? correctId}) =>
      SuspectState(
        selectedId: selectedId ?? this.selectedId,
        correctId: correctId ?? this.correctId,
      );
}

class SuspectCubit extends Cubit<SuspectState> {
  SuspectCubit({String? correctSuspectId})
      : super(SuspectState(selectedId: null, correctId: correctSuspectId));

  void select(String id) {
    if (state.selectedId != null) return; 
    emit(state.copyWith(selectedId: id));
  }

  void reset() {
    emit(state.copyWith(selectedId: null));
  }
}
