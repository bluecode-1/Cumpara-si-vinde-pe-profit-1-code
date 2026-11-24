// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProblemDto _$ProblemDtoFromJson(Map<String, dynamic> json) => _ProblemDto(
  type: json['type'] as String,
  title: json['title'] as String,
  status: (json['status'] as num).toInt(),
  code: json['code'] as String,
  detail: json['detail'] as String?,
  errors: (json['errors'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
  ),
);

Map<String, dynamic> _$ProblemDtoToJson(_ProblemDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'status': instance.status,
      'code': instance.code,
      'detail': instance.detail,
      'errors': instance.errors,
    };
