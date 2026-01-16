import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twisted_files/domain/entities/case_entity.dart';

class EvidenceDetailsViewModel extends Cubit<void> {
  final CaseEntity caseEntity;
  final dynamic item; 
  final bool isSuspect;

  EvidenceDetailsViewModel({
    required this.caseEntity,
    required this.item,
    required this.isSuspect,
  }) : super(null);

  String get title => isSuspect ? (item?.name ?? '') : (item?.title ?? '');
  String get content => isSuspect ? (item?.description ?? '') : (item?.content ?? '');
}