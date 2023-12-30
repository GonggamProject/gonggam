// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StringResponse _$StringResponseFromJson(Map<String, dynamic> json) =>
    StringResponse(
      json['code'] as String,
      json['message'] as String,
      json['content'] as String,
    );

Map<String, dynamic> _$StringResponseToJson(StringResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'content': instance.content,
    };
