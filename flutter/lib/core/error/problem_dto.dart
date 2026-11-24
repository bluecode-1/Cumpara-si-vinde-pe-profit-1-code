import 'package:freezed_annotation/freezed_annotation.dart';

part 'problem_dto.freezed.dart';
part 'problem_dto.g.dart';

/// RFC 9457 problem document (`application/problem+json`).
@freezed
abstract class ProblemDto with _$ProblemDto {
  const factory ProblemDto({
    required String type,
    required String title,
    required int status,
    required String code,
    String? detail,
    Map<String, List<String>>? errors,
  }) = _ProblemDto;

  factory ProblemDto.fromJson(Map<String, dynamic> json) =>
      _$ProblemDtoFromJson(json);
}
