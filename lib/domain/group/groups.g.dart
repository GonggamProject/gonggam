// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groups.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Groups _$GroupsFromJson(Map<String, dynamic> json) => Groups(
      (json['groups'] as List<dynamic>)
          .map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupsToJson(Groups instance) => <String, dynamic>{
      'groups': instance.groups,
    };
