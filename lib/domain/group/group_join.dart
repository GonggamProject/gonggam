import 'package:json_annotation/json_annotation.dart';

part 'group_join.g.dart';

@JsonSerializable()
class GroupJoin {
  int groupId;
  String groupName;

  GroupJoin(this.groupId, this.groupName);

  factory GroupJoin.fromJson(Map<String, dynamic> json) => _$GroupJoinFromJson(json);
  Map<String, dynamic> toJson() => _$GroupJoinToJson(this);
}