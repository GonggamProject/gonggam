import 'package:json_annotation/json_annotation.dart';

part 'pushes_get.g.dart';

@JsonSerializable()
class PushesGet {
  bool isNoticeMemberNewNote;
  int? hourForRemind;

  PushesGet(this.isNoticeMemberNewNote, this.hourForRemind);

  bool getPushStatus() {
    return isNoticeMemberNewNote || hourForRemind != null;
  }

  bool isTimeForMyNewNote() {
    return isTimeForMyNewNote != null;
  }

  factory PushesGet.fromJson(Map<String, dynamic> json) => _$PushesGetFromJson(json);
  Map<String, dynamic> toJson() => _$PushesGetToJson(this);
}