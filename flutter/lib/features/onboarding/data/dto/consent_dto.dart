import 'package:freezed_annotation/freezed_annotation.dart';

part 'consent_dto.freezed.dart';
part 'consent_dto.g.dart';

/// `ConsentPurpose` schema.
@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum ConsentPurposeDto {
  terms,
  privacy,
  marketing,
  analytics,
  location,
  aiPhotoProcessing,

  /// A purpose introduced by a newer backend.
  unknown,
}

/// `Consent` schema: item of the `GET /me/consents` response.
@freezed
abstract class ConsentDto with _$ConsentDto {
  const factory ConsentDto({
    @JsonKey(unknownEnumValue: ConsentPurposeDto.unknown)
    required ConsentPurposeDto purpose,
    required bool granted,
    required String policyVersion,
    required DateTime updatedAt,
  }) = _ConsentDto;

  factory ConsentDto.fromJson(Map<String, dynamic> json) =>
      _$ConsentDtoFromJson(json);
}

/// Item of the `PUT /me/consents` request body.
@freezed
abstract class ConsentUpdateDto with _$ConsentUpdateDto {
  const factory ConsentUpdateDto({
    required ConsentPurposeDto purpose,
    required bool granted,
    required String policyVersion,
  }) = _ConsentUpdateDto;

  factory ConsentUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$ConsentUpdateDtoFromJson(json);
}
