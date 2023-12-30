// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notes _$NotesFromJson(Map<String, dynamic> json) => Notes(
      json['groupId'] as int? ?? 0,
      json['targetedAt'] as String? ?? '',
      (json['list'] as List<dynamic>)
          .map((e) => Note.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotesToJson(Notes instance) => <String, dynamic>{
      'groupId': instance.groupId,
      'targetedAt': instance.targetedAt,
      'list': instance.list,
    };
