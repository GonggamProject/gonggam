import 'package:json_annotation/json_annotation.dart';

enum Rule {
  @JsonValue("OWNER")
  owner,
  @JsonValue("MEMBER")
  member;

  bool isOwner(){
    return this == Rule.owner;
  }
}