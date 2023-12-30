// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      json['noteId'] as int?,
      json['content'] as String,
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'noteId': instance.noteId,
      'content': instance.content,
    };
