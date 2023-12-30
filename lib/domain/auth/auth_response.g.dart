// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      json['token'] as String,
      json['isNewCustomer'] as bool,
      json['nickname'] as String,
      json['customerId'] as String,
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'isNewCustomer': instance.isNewCustomer,
      'nickname': instance.nickname,
      'customerId': instance.customerId,
    };
