import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:twisted_files/data/data_source/local_case_data_source.dart';
import 'package:twisted_files/data/models/case_model.dart';

class LocalCaseDataSourceImpl implements LocalCaseDataSource{
  @override
  Future<CaseModel> loadCase(String caseId) async {
  final jsonString =
      await rootBundle.loadString('assets/data/cases/$caseId.json');

  final jsonMap = json.decode(jsonString);
  return CaseModel.fromJson(jsonMap);
}

}