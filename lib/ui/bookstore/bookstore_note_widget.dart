import 'package:flutter/material.dart';
import 'package:gonggam/controller/group_controller.dart';
import 'package:gonggam/service/group/group_service.dart';
import 'package:gonggam/service/note/note_service.dart';
import 'package:get/get.dart';
import 'package:gonggam/ui/bookstore/bookstore_main.dart';

import '../../common/constants.dart';
import '../../common/prefs.dart';
import '../../domain/note/note.dart';
import '../../domain/note/notes.dart';
import '../../domain/common/response.dart' as gonggam_response;

import '../../utils.dart';
import '../common/alert.dart';
import '../createNote/create_note_page.dart';

Widget noteFactory(BuildContext context, int currentDateState, String customerId, GroupController groupController) {
  String writerName = "";
  try {
    writerName = groupController.group.members.firstWhere((element) => element.customerId == customerId).nickname;
  } catch (e) {
    Alert.alertDialog("오류발생(mike에게 공유) - groupId : ${groupController.group.id}, customerId : $customerId, members : ${groupController.group.members.join(",")}");
  }

  return FutureBuilder(
      future: NoteService.getNoteList(customerId, groupController.group.id, Utils.formatDate("yyyyMMdd", currentDateState)),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SizedBox(width: 10, height: 10, child: CircularProgressIndicator(),));
        } else {
          gonggam_response.Response<Notes> noteRes = snapshot.data!;
          if(currentDateState == 0) { // 오늘 데이터
            if(noteRes.content!.list.isEmpty) {
              if(customerId == Prefs.getCustomerId()) {
                return getBeforeWriteMyNote(groupController.group.name, groupController.group.id);
              } else {
                if(noteRes.code == "GG3003") {
                  return getBeforeWriteMyNoteAndReadOtherNote();
                } else {
                  return getBeforeWriteOtherNote(writerName);
                }
              }
            } else {
              return getNote(context, noteRes.content!.list, writerName, customerId, currentDateState, groupController.group.id);
            }
          } else { // 다른날데이터
            if (noteRes.content!.list.isEmpty) {
              return getBlankNote(currentDateState);
            } else {
              return getNote(context, noteRes.content!.list, writerName, customerId, currentDateState, groupController.group.id);
            }
          }
        }
      });
}

// 날짜 지난 비어있는 일기
Widget getBlankNote(int currentDateState) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("${Utils.formatDate("yyy.MM.dd", currentDateState)}에는"),
        const Text("감사일기 작성을 쉬었어요."),
      ],
    ),
  );
}

// 내 일기 - 쓰기전
Widget getBeforeWriteMyNote(String currentGroupName, int selectedGroupId) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Get.to(const CreateNoteWidget(), duration: const Duration(seconds: 0));
          },
          child: Container(
            height: 138,
            width: 292,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "오늘 하루",
                  style: TextStyle(
                      fontFamily: FONT_APPLESD,
                      fontSize: 15,
                      color: COLOR_GRAY),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "감사한 일을 적어주세요.",
                  style: TextStyle(
                      fontFamily: FONT_APPLESD,
                      fontSize: 15,
                      color: COLOR_GRAY),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "감사일기 작성하기",
                  style: TextStyle(
                    fontFamily: FONT_APPLESD,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
        // InkWell(
        //   onTap: () {
        //     AuthFactory.createAuthService(Prefs.currentLoginedPlatform())
        //         .logout();
        //   },
        //   child: Text("Logout"),
        // )
      ],
    ),
  );
}

// 내 일기 쓰기전에 다른 사람일기 읽기시
Widget getBeforeWriteMyNoteAndReadOtherNote() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Get.to(const CreateNoteWidget(), duration: const Duration(seconds: 0));
          },
          child: const SizedBox(
            height: 138,
            width: 292,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "오늘 하루 나의 감사한 일을 적고",
                  style: TextStyle(
                      fontFamily: FONT_APPLESD,
                      fontSize: 15,
                      color: COLOR_GRAY),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "친구의 감사 일기를 확인해보세요!",
                  style: TextStyle(
                      fontFamily: FONT_APPLESD,
                      fontSize: 15,
                      color: COLOR_GRAY),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "감사일기 작성하기",
                  style: TextStyle(
                    fontFamily: FONT_APPLESD,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// 다른유저 일기 - 쓰기전
Widget getBeforeWriteOtherNote(String customerName) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$customerName님이",
          style: const TextStyle(
              fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_GRAY),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          "감사일기를 작성하기 전이에요!",
          style: TextStyle(
              fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_GRAY),
        ),
      ],
    ),
  );
}

// 일기 가져오기
Widget getNote(BuildContext context, List<Note> noteData, String writerName, String customerId, int currentDateState, int groupId) {
  return Container(
    padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: getNoteWidgets(context, noteData, writerName, customerId, currentDateState, groupId),
    ),
  );
}

// 일기 내용물 그리기
List<Widget> getNoteWidgets(BuildContext context, List<Note> noteData, String writerName, String customerId, int currentDateState, int groupId) {
  List<Widget> widgets = [];

  // 상단 기능
  widgets.add(Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text("written by $writerName"),
      customerId == Prefs.getCustomerId() ?
      SizedBox(
        width: 21,
        height: 21,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Image.asset("$IMAGE_PATH/button_note_setting.png"),
          iconSize: 21.0,
          onPressed: () {
            showSettingModal(context, currentDateState, groupId);
          },
        ),
      ) : const SizedBox.shrink()
    ],
  ));

  // 공백
  widgets.add(const SizedBox(
    height: 36,
  ));

  // 내용 추가
  for (int i = 0; i < noteData.length; i++) {
    widgets.add(Text("${i + 1}. ${noteData[i].content}"));
    if (i < noteData.length - 1) {
      widgets.add(const SizedBox(
        height: 21,
      ));
    }
  }
  return widgets;
}

Future showSettingModal(BuildContext context, int currentDateState, int groupId) {
  return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Padding(
            padding: const EdgeInsets.fromLTRB(30, 40, 30, 50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.to(const CreateNoteWidget(), arguments: currentDateState);
                      },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                          color: COLOR_SUB,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        "감사일기 수정",
                        style: TextStyle(
                            fontFamily: FONT_APPLESD,
                            fontSize: 15,
                            color: COLOR_SUB),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Alert.confirmDialog(context, "${Utils.formatDate("yyyy.MM.dd", currentDateState)} 감사일기를 삭제할까요?",
                            "삭제하면 복구 할 수 없어요!\n신중하게 선택해주세요.", "감사일기삭제", () {
                              NoteService.deleteNote(Utils.formatDate("yyyyMMdd", currentDateState), groupId).then((value) => {
                                Get.off(const BookStoreMainWidget(), arguments: true)
                              });
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                          color: COLOR_SUB,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        "감사일기 삭제",
                        style: TextStyle(
                            fontFamily: FONT_APPLESD,
                            fontSize: 15,
                            color: COLOR_SUB),
                      ),
                    ),
                  ),
                ]));
      });
}