// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pushes_get.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushesGet _$PushesGetFromJson(Map<String, dynamic> json) => PushesGet(
      json['isNoticeMemberNewNote'] as bool,
      json['hourForRemind'] as int?,
    );

Map<String, dynamic> _$PushesGetToJson(PushesGet instance) => <String, dynamic>{
      'isNoticeMemberNewNote': instance.isNoticeMemberNewNote,
      'hourForRemind': instance.hourForRemind,
    };
