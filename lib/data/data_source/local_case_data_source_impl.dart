import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:twisted_files/data/models/case_model.dart';
import 'package:twisted_files/data/data_source/local_case_data_source.dart';

class LocalCaseDataSourceImpl implements LocalCaseDataSource {
  @override
  Future<CaseModel> loadCase(String caseId) async {
    final jsonString = await rootBundle.loadString('assets/data/cases/easy/$caseId.json');
    final jsonMap = json.decode(jsonString);
    return CaseModel.fromJson(jsonMap);
  }

  @override
  Future<List<CaseModel>> loadAllCases() async {
    final indexString = await rootBundle.loadString('assets/data/cases/easy/cases_index.json');
    final List<dynamic> files = json.decode(indexString);

    List<CaseModel> cases = [];

    for (var fileName in files) {
      final jsonString = await rootBundle.loadString('assets/data/cases/easy/$fileName');
      final jsonMap = json.decode(jsonString);
      cases.add(CaseModel.fromJson(jsonMap));
    }

    return cases;
  }
  
}