import 'package:json_annotation/json_annotation.dart';
import 'group.dart';

part 'groups.g.dart';

@JsonSerializable()
class Groups {
  List<Group> groups;

  Groups(this.groups);

  factory Groups.fromJson(Map<String, dynamic> json) => _$GroupsFromJson(json);
  Map<String, dynamic> toJson() => _$GroupsToJson(this);
}