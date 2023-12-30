import 'package:gonggam/domain/enum/enum_rule.dart';
import 'package:json_annotation/json_annotation.dart';
part 'member.g.dart';

@JsonSerializable()
class Member {
  final String customerId;
  final String nickname;
  final String profileImage;
  final Rule rule;

  Member(this.customerId, this.nickname, this.profileImage, this.rule);

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);
}