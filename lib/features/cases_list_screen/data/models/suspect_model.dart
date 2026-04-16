import 'package:twisted_files/features/cases_list_screen/domain/entities/suspect_entity.dart';

class SuspectModel {
  final String id;
  final String name;
  final String description;

  const SuspectModel({required this.id, required this.name, required this.description});

  factory SuspectModel.fromJson(Map<String, dynamic> json) => SuspectModel(
    id: json['id'], name: json['name'], description: json['description'],
  );

  SuspectEntity toEntity() => SuspectEntity(id: id, name: name, description: description);
}
