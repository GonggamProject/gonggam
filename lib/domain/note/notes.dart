import 'package:json_annotation/json_annotation.dart';

import 'note.dart';

part 'notes.g.dart';

@JsonSerializable()
class Notes {
  @JsonKey(defaultValue: 0)
  int? groupId;
  @JsonKey(defaultValue: "")
  String targetedAt;
  List<Note> list;
  @JsonKey(defaultValue: false)
  bool isWriteAll;

  Notes(this.groupId, this.targetedAt, this.list, this.isWriteAll);

  factory Notes.fromJson(Map<String, dynamic> json) => _$NotesFromJson(json);
  Map<String, dynamic> toJson() => _$NotesToJson(this);

  static Notes empty() {
    return Notes(
      0, "", [], false
    );
  }
}