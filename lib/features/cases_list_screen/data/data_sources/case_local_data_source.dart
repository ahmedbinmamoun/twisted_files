import 'package:twisted_files/features/cases_list_screen/data/models/case_model.dart';

abstract class CaseLocalDataSource {
  Future<CaseModel> loadCase(String caseId);
  Future<List<CaseModel>> loadAllCases();
}
