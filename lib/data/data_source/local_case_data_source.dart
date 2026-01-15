import 'package:twisted_files/data/models/case_model.dart';
import 'package:twisted_files/data/models/case_progress_model.dart';

abstract class LocalCaseDataSource {
  Future <CaseModel> loadCase(String caseId);
  Future<List<CaseModel>> loadAllCases();
  Future<void> saveCaseProgress(CaseProgressModel model);
  Future<List<CaseProgressModel>> getAllCompletedCases();

}