import 'package:twisted_files/domain/entities/suspect_entity.dart';

class SuspectModel {
  final String id;
  final String name;
  final String description;

  SuspectModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory SuspectModel.fromJson(Map<String, dynamic> json) {
    return SuspectModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  SuspectEntity toEntity() {
    return SuspectEntity(
      id: id,
      name: name, description: description,
    );
  }
}