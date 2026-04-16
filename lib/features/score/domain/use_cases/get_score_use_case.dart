import 'package:twisted_files/features/score/domain/entities/score_entity.dart';
import 'package:twisted_files/features/score/domain/repositories/score_repository.dart';

class GetScoreUseCase {
  final ScoreRepository _repository;
  const GetScoreUseCase(this._repository);

  Future<ScoreEntity> call() => _repository.getScore();
}
