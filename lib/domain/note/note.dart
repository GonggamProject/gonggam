import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  int? noteId;
  String content;

  Note(this.noteId, this.content);

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}