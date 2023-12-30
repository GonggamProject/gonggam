// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      json['id'] as int,
      json['name'] as String,
      json['isRepresentation'] as bool? ?? false,
      (json['members'] as List<dynamic>?)
              ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      json['isUpdated'] as bool? ?? false,
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isRepresentation': instance.isRepresentation,
      'members': instance.members,
      'isUpdated': instance.isUpdated,
    };
