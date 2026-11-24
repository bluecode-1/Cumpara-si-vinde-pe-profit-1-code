// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) => _CategoryDto(
  id: json['id'] as String,
  slug: json['slug'] as String,
  name: json['name'] as String,
  parentId: json['parentId'] as String?,
  iconKey: json['iconKey'] as String?,
  isVehicle: json['isVehicle'] as bool? ?? false,
);

Map<String, dynamic> _$CategoryDtoToJson(_CategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'parentId': instance.parentId,
      'iconKey': instance.iconKey,
      'isVehicle': instance.isVehicle,
    };
