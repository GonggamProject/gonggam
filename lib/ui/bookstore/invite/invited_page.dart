import 'package:flutter/material.dart';
import 'package:gonggam/controller/invite_controller.dart';
import 'package:get/get.dart';
import 'package:gonggam/domain/group/group.dart';
import 'package:gonggam/ui/bookstore/bookstore_main.dart';

import '../../../common/constants.dart';
import '../../../common/prefs.dart';
import '../../../controller/group_controller.dart';
import '../../../domain/group/groups.dart';
import '../../../service/group/group_service.dart';
import '../../createBookstore/create_bookstore_main_page.dart';
import 'invited_result_page.dart';

class InvitedPage extends StatefulWidget {
  const InvitedPage({super.key});

  @override
  State<InvitedPage> createState() => _InvitedPageState();
}

class _InvitedPageState extends State<InvitedPage> {
  InviteController inviteController = Get.find();

  void inviteProcess() async {
    List<String> errCodes = ["GG2000", "GG2001", "GG2005"];
    String resCode = await GroupService.joinGroup(inviteController.inviteCode);

    if(errCodes.contains(resCode)) {
      Get.off(const InvitedResultPage(), arguments: resCode);
    } else {
      Groups groups = await GroupService.getGroupList();
      if (!Get.isRegistered<GroupController>()) {
        Group group = groups.groups.firstWhere((element) =>
        inviteController.groupId == 0 ? element.isRepresentation : element
            .id == inviteController.groupId);
        Get.put(GroupController(groups, group.copyWith()), permanent: true);
      } else {
        GroupController groupController = Get.find<GroupController>();
        groupController.setGroup(groups.groups.firstWhere((element) => element.id == inviteController.groupId).copyWith());
      }
      Get.off(const BookStoreMainWidget());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: COLOR_BACKGROUND,
        body: SafeArea(
            minimum: PADDING_MINIMUM_SAFEAREA,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 130,),
                      Text("${inviteController.inviterName}님이 ${inviteController
                          .groupName}에",
                        style: const TextStyle(fontFamily: FONT_APPLESD,
                            fontSize: 21,
                            color: COLOR_BOOK5,
                            fontWeight: FontWeight.bold),),
                      const SizedBox(height: 5,),
                      Text("${Prefs.getCustomerName()}님을 초대했어요!",
                        style: const TextStyle(fontFamily: FONT_APPLESD,
                            fontSize: 21,
                            color: COLOR_BOOK5,
                            fontWeight: FontWeight.bold),),
                      Image.asset(
                        "$IMAGE_PATH/invite_image.png", width: 227,
                        height: 207,),
                      const SizedBox(height: 20,),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 60,
                      child: ElevatedButton(onPressed: () async {
                        Get.off(const CreateBookStoreMainWidget());
                      },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text("초대 거절하기",
                          style: TextStyle(fontFamily: FONT_APPLESD,
                              fontSize: 18,
                              color: Colors.black),),
                      ),),
                    SizedBox(
                      width: 150,
                      height: 60,
                      child: ElevatedButton(onPressed: () async {
                        inviteProcess();
                      },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: COLOR_BOOK5,
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text("책방 방문하기",
                          style: TextStyle(
                              fontFamily: FONT_APPLESD, fontSize: 18),),
                      ),),
                  ],)
              ],
            )
        )
    );
  }
}
