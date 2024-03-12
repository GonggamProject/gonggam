import 'dart:collection';
import 'dart:ffi';

import 'package:gonggam/common/http/http_client.dart';
import 'package:gonggam/domain/note/calendar.dart';

import '../../common/prefs.dart';
import '../../domain/common/response.dart';
import '../../domain/note/note.dart';
import '../../domain/note/notes.dart';
import '../../ui/createNote/create_note_page.dart';

class NoteService {
  static Future<void> postNoteList(int groupId, String targetedAt, LinkedList<NoteData> noteList, bool isEditMode, bool isWriteAll) async {
    Notes notes = Notes(groupId, targetedAt, noteList.map((e) => Note(e.noteId, e.getNoteText())).toList(), isWriteAll);
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

  static Future<Calendar> getCalendar(int groupId, String? targetCustomerId, String yyyyMM) async {
    String queryParams = "?";

    queryParams += "groupId=$groupId";
    if(targetCustomerId != Prefs.getCustomerId()) {
      queryParams += "&targetCustomerId=$targetCustomerId";
    }
    queryParams += "&yyyyMM=$yyyyMM";

    final response = await GongGamHttpClient().getRequest("/v1/calender$queryParams", null);
    Response<Calendar> res = Response.fromJson(response.data, (json) => Calendar.fromJson(json as Map<String, dynamic>));
    return res.content!;
  }
}