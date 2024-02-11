import 'package:json_annotation/json_annotation.dart';

part 'pushes_update.g.dart';

@JsonSerializable()
class PushesUpdate {
  bool isNoticeMemberNewNote;
  int? timeForMyNewNote;

  PushesUpdate(this.isNoticeMemberNewNote, this.timeForMyNewNote);

  factory PushesUpdate.fromJson(Map<String, dynamic> json) => _$PushesUpdateFromJson(json);
  Map<String, dynamic> toJson() => _$PushesUpdateToJson(this);
}