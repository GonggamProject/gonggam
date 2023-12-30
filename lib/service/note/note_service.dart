import 'dart:collection';

import 'package:gonggam/common/http/http_client.dart';

import '../../domain/common/response.dart';
import '../../domain/note/note.dart';
import '../../domain/note/notes.dart';
import '../../ui/createNote/create_note_page.dart';

class NoteService {
  static Future<void> postNoteList(int groupId, String targetedAt, LinkedList<NoteData> noteList, bool isEditMode) async {
    Notes notes = Notes(groupId, targetedAt, noteList.map((e) => Note(isEditMode ? e.noteId : null, e.getNoteText())).toList());
    await GongGamHttpClient().postRequest("/v1/notes", notes.toJson());
  }

  static Future<Response<Notes>> getNoteList(String? targetCustomerId, int groupId, String targetedAt) async {
    String queryParams = "?";

    if(targetCustomerId != null) {
      queryParams += "targetCustomerId=$targetCustomerId&";
    }
    queryParams += "groupId=$groupId";
    queryParams += "&targetedAt=$targetedAt";
    final response = await GongGamHttpClient().getRequest("/v1/notes$queryParams", null);

    Response<Notes> res = Response.fromJson(response.data, (json) => Notes.fromJson(json as Map<String, dynamic>));
    res.content ??= Notes.empty();
    return res;
  }

  static Future<void> deleteNote(String targetedAt, int groupId) async {
    await GongGamHttpClient().deleteRequest("/v1/notes", {"targetedAt": targetedAt, "groupId": groupId});
  }

  // static Future<void> updateNoteList(int groupId, String targetedAt, LinkedList<NoteData> noteList) async {
  //   Notes notes = Notes(groupId, targetedAt, noteList.indexed.map((e) => Note(e.$1, e.$2.getNoteText())).toList());
  //   GongGamHttpClient().postRequest("/v1/notes", notes.toJson());
  // }
}