import 'package:twisted_files/data/models/case_model.dart';

abstract class LocalCaseDataSource {
  Future <CaseModel> loadCase(String caseId);
  Future<List<CaseModel>> loadAllCases();

}