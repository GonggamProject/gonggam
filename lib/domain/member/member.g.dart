// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      json['customerId'] as String,
      json['nickname'] as String,
      json['profileImage'] as String,
      $enumDecode(_$RuleEnumMap, json['rule']),
    );

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'customerId': instance.customerId,
      'nickname': instance.nickname,
      'profileImage': instance.profileImage,
      'rule': _$RuleEnumMap[instance.rule]!,
    };

const _$RuleEnumMap = {
  Rule.owner: 'OWNER',
  Rule.member: 'MEMBER',
};
