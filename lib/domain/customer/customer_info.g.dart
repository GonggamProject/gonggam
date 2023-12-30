// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerInfo _$CustomerInfoFromJson(Map<String, dynamic> json) => CustomerInfo(
      json['nickname'] as String,
      json['profileImage'] as String,
      json['state'] as String,
    );

Map<String, dynamic> _$CustomerInfoToJson(CustomerInfo instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'profileImage': instance.profileImage,
      'state': instance.state,
    };
