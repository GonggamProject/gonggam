import 'package:json_annotation/json_annotation.dart';

part 'group_invite_key.g.dart';

@JsonSerializable()
class GroupInviteKey {
  String key;

  GroupInviteKey(this.key);

  factory GroupInviteKey.fromJson(Map<String, dynamic> json) => _$GroupInviteKeyFromJson(json);
  Map<String, dynamic> toJson() => _$GroupInviteKeyToJson(this);
}