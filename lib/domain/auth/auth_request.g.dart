// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRequest _$AuthRequestFromJson(Map<String, dynamic> json) => AuthRequest(
      json['uid'] as String,
      json['platformType'] as String,
      json['nickname'] as String?,
      json['profileImageUrl'] as String?,
      json['token'] as String?,
    );

Map<String, dynamic> _$AuthRequestToJson(AuthRequest instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'platformType': instance.platformType,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'token': instance.token,
    };
