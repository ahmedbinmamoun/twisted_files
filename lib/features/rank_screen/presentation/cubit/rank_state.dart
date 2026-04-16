import 'package:twisted_files/features/rank_screen/domain/entities/rank_entry_entity.dart';

abstract class RankState {}

class RankLoading extends RankState {}

class RankLoaded extends RankState {
  final List<RankEntryEntity> entries;
  final RankEntryEntity?      currentUserEntry;
  RankLoaded({required this.entries, this.currentUserEntry});
}

class RankError extends RankState {
  final String message;
  RankError(this.message);
}
