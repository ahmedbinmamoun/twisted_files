import 'package:twisted_files/domain/entities/case_entity.dart';
import 'package:twisted_files/domain/repositories/case_repository.dart';

class GetCasesListUseCase {

  final CaseRepository repository;
  GetCasesListUseCase(this.repository);

  Future<List<CaseEntity>> call() async{
    return await repository.getAllCases();
  }
  
}