import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gonggam/controller/group_controller.dart';
import 'package:gonggam/service/note/note_service.dart';
import 'package:gonggam/ui/bookstore/bookstore_main.dart';
import 'package:gonggam/ui/createNote/create_note_page.dart';
import 'package:gonggam/ui/setting/setting_page.dart';
import 'package:gonggam/utils.dart';

import '../../common/prefs.dart';
import '../createBookstore/create_bookstore_main_page.dart';
import '../createBookstore/create_bookstore_name_page.dart';
import 'alert.dart';
import '../../common/constants.dart';

Widget getBottomNavigationBar(BuildContext context, GroupController? groupController, int currentNavIndex) {
  return BottomAppBar(
    child: Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: COLOR_LIGHTGRAY,
            width: 3.0
          )
        )
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Image.asset(currentNavIndex == 0 ? "$IMAGE_PATH/bottom_home_active_icon.png" : "$IMAGE_PATH/bottom_home_icon.png", width: 26, height: 26,),
            onPressed: () {
               Get.off(groupController != null && groupController!.groups.groups.isNotEmpty ? const BookStoreMainWidget() : const CreateBookStoreMainWidget(), duration: const Duration(seconds: 0), arguments: {"isRefresh": false});
            },
          ),
          IconButton(
            icon: Image.asset(currentNavIndex == 1 ? "$IMAGE_PATH/bottom_create_active_icon.png" : "$IMAGE_PATH/bottom_create_icon.png", width: 26, height: 26,),
            onPressed: () {
              if (groupController != null && groupController!.groups.groups.isNotEmpty) {
                NoteService.getNoteList(null, groupController!.group.id, Utils.formatDate("yyyyMMdd", 0)).then((value) {
                  if(value.content!.list.isNotEmpty) {
                    Alert.alertDialog("이미 오늘의 감사일기를 작성했어요.");
                  } else {
                    Get.to(const CreateNoteWidget(), duration: const Duration(seconds: 0));
                  }
                });
              } else {
                Alert.confirmDialog("", "책방 생성 또는 참여 후\n감사일기를 작성할 수 있어요.", "책방 만들기", () => {
                  Get.to(const CreateBookStoreNameWidget())
                });
              }
            },
          ),
          IconButton(
            icon: Image.asset(currentNavIndex == 2 ? "$IMAGE_PATH/bottom_my_active_icon.png" : "$IMAGE_PATH/bottom_my_icon.png", width: 26, height: 26,),
            onPressed: () {
              Get.off(const SettingPageWidget(), duration: const Duration(seconds: 0));
            },
          ),
        ],
      ),
    ),
  );
}
