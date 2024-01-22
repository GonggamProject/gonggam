import 'package:json_annotation/json_annotation.dart';
import '../member/member.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  int id;
  String name;
  @JsonKey(name: "isRepresentation", defaultValue: false)
  bool isRepresentation;
  @JsonKey(name: "members", defaultValue: [])
  List<Member> members;
  @JsonKey(name: "isUpdated", defaultValue: false)
  bool isUpdated;
  String createdAt;

  Group(this.id, this.name, this.isRepresentation, this.members, this.isUpdated, this.createdAt);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);

  Group copyWith() {
    return Group(
      id,
      name,
      isRepresentation,
      members,
      isUpdated,
      createdAt
    );
  }
}