import 'package:twisted_files/features/cases_list_screen/domain/entities/evidence_entity.dart';

class EvidenceModel {
  final String id;
  final String title;
  final String content;

  const EvidenceModel({required this.id, required this.title, required this.content});

  factory EvidenceModel.fromJson(Map<String, dynamic> json) => EvidenceModel(
    id: json['id'], title: json['title'], content: json['content'],
  );

  EvidenceEntity toEntity() => EvidenceEntity(id: id, title: title, content: content);
}
