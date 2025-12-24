import 'package:twisted_files/domain/entities/evidence_entity.dart';

class EvidenceModel {
  final String id;
  final String title;
  final String content;

  EvidenceModel({
    required this.id,
    required this.title,
    required this.content,
  });

  factory EvidenceModel.fromJson(Map<String, dynamic> json) {
    return EvidenceModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }

  EvidenceEntity toEntity() {
    return EvidenceEntity(
      id: id,
      title: title,
      content: content,
    );
  }
}