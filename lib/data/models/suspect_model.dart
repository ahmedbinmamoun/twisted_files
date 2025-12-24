import 'package:twisted_files/domain/entities/suspect_entity.dart';

class SuspectModel {
  final String id;
  final String name;

  SuspectModel({
    required this.id,
    required this.name,
  });

  factory SuspectModel.fromJson(Map<String, dynamic> json) {
    return SuspectModel(
      id: json['id'],
      name: json['name'],
    );
  }

  SuspectEntity toEntity() {
    return SuspectEntity(
      id: id,
      name: name,
    );
  }
}