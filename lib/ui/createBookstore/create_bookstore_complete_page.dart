import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gonggam/common/prefs.dart';
import 'package:gonggam/controller/group_controller.dart';
import 'package:gonggam/ui/bookstore/invite/invite_page.dart';
import 'package:gonggam/ui/common/note_list_menu.dart';

import '../../domain/group/group.dart';
import '../common/bookstore_list_modal.dart';
import '../common/bottom_navigation_bar.dart';
import '../../common/constants.dart';
import '../createNote/create_note_page.dart';

class CreateBookStoreCompleteWidget extends StatefulWidget {
  const CreateBookStoreCompleteWidget({super.key});

  @override
  State<CreateBookStoreCompleteWidget> createState() =>
      _CreateBookStoreCompleteWidgetState();
}

class _CreateBookStoreCompleteWidgetState extends State<CreateBookStoreCompleteWidget> {
  final GroupController groupController = Get.find<GroupController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: COLOR_BACKGROUND,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: GestureDetector(
            onTap: () {
              showBookStoreListModal(context, groupController, (id) {
                Group group = groupController.groups.groups.firstWhere((element) => element.id == id);
                groupController.setGroup(group.copyWith());
                setState(() {});
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  groupController.group.name,
                  style: const TextStyle(
                      fontFamily: FONT_NANUMMYNGJO,
                      fontSize: 15,
                      color: Colors.black),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                )
              ],
            ),
          ),
          foregroundColor: Colors.black,
          backgroundColor: COLOR_BACKGROUND,
          elevation: 0,
        ),
        body: SafeArea(
            minimum: PADDING_MINIMUM_SAFEAREA,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 65,),
                      Image.asset("$IMAGE_PATH/create_bookstore_main_image.png", width: 177, height: 198,),
                      const SizedBox(height: 15,),
                      Text('"${groupController.group.name}"', style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: COLOR_SUB),),
                      const SizedBox(height: 5,),
                      const Text("책방에 오신걸 환영해요!", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: COLOR_SUB),),
                      const SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          groupController.group.members.firstWhere((element) => element.customerId == Prefs.getCustomerId()).rule.isOwner() ?
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              height: 50,
                              child: ElevatedButton(onPressed: () {
                                Get.to(const InvitePage());
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
                                child: const Text("책방 초대하기", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB),),
                              ),
                            ),
                          ) : const SizedBox.shrink(),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              height: 50,
                              child: ElevatedButton(onPressed: () {
                                Get.to(const CreateNoteWidget());
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
                                child: const Text("감사일기 쓰기", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],),
                ),
                SizedBox(
                  child: FutureBuilder(
                    future: getBottomNoteList(groupController.group.id, Prefs.getCustomerId(), (customerId) {
                      setState(() {});
                    }),
                    builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // 데이터가 로딩 중일 때 표시할 위젯
                      } else {
                        return Stack(children: snapshot.data!);
                      }
                    },
                  ),
                )
              ],)
        ),
        bottomNavigationBar: getBottomNavigationBar(context, groupController, 0)
    );
  }
}
