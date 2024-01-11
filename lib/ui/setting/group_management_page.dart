import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gonggam/controller/group_controller.dart';
import 'package:gonggam/domain/group/group.dart';
import 'package:gonggam/service/group/group_service.dart';
import 'package:gonggam/ui/common/alert.dart';
import 'package:gonggam/ui/createBookstore/create_bookstore_name_page.dart';
import 'package:gonggam/ui/setting/leave_group_page.dart';
import 'package:gonggam/ui/setting/member_management_page.dart';
import 'package:gonggam/ui/setting/remove_group_page.dart';
import '../../common/constants.dart';
import '../../common/prefs.dart';

class GroupManagementPageWidget extends StatefulWidget {
  const GroupManagementPageWidget({super.key});

  @override
  State<GroupManagementPageWidget> createState() => _GroupManagementPageWidgetState();
}

class _GroupManagementPageWidgetState extends State<GroupManagementPageWidget> {
  final GroupController groupController = Get.find<GroupController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: COLOR_BACKGROUND,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("책방관리", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18),),
          foregroundColor: Colors.black,
          backgroundColor: COLOR_BACKGROUND,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios), onPressed: () {
              Get.back();
            },
          ),
        ),
        body: SafeArea(
            minimum: PADDING_MINIMUM_SAFEAREA,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: groupController.groups.groups.isNotEmpty ? getGroupManagementWidgets() : getEmptyWidget()
            )
        ),
    );
  }

  List<Widget> getGroupManagementWidgets() {
    List<Widget> widgets = [];
    widgets.addAll(getManagementHeadWidgets());
    widgets.addAll(getGroupWidgets());
    return widgets;
  }

  List<Widget> getManagementHeadWidgets() {
    return [
      const SizedBox(height: 30,),
      Row(
        children: [
          const Text("총 ", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15),),
          Text(groupController.groups.groups.length.toString(), style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_BLUE, fontWeight: FontWeight.bold),),
          const Text("개의 책방에 참여중이에요.", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15),)
        ],
      ),
      const SizedBox(height: 25,),
      const Divider(thickness: 1.5, height: 1, color: COLOR_LIGHTGRAY),
      const SizedBox(height: 25,),
    ];
  }

  List<Widget> getGroupWidgets() {
    List<Widget> widgets = [];

    for (var group in groupController.groups.groups) {
      bool isOwner = group.members.firstWhere((element) => element.customerId == Prefs.getCustomerId()).rule.isOwner();

      widgets.add(
          SizedBox(
            width: double.infinity,
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: COLOR_LIGHTGRAY,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            getMemberLabel(isOwner),
                            const SizedBox(width: 10,),
                            Text(group.name, style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, fontWeight: FontWeight.bold),),
                          ],),
                          group.isRepresentation ? const Icon(Icons.star_rate_rounded, size: 25,) :
                          GestureDetector(
                            child: const Icon(Icons.star_rate_rounded, size: 25, color: Colors.white,),
                            onTap: () => {
                              changeRepresentGroup(group)
                            },
                          )
                        ],),
                      const SizedBox(height: 15,),
                      isOwner ? InkWell(onTap: () => {
                        Get.to(const MemberManagementPageWidget(), arguments: group)
                      }, child: const Text("멤버관리", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB),)) : const SizedBox.shrink(),
                      isOwner ? const SizedBox(height: 10,) : const SizedBox.shrink(),
                      isOwner ?
                      InkWell(onTap: () => {
                        Get.to(const RemoveGroupPageWidget(), arguments: {"groupId": group.id, "groupName": group.name})
                      }, child: const Text("책방삭제", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB),)) :
                      InkWell(onTap: () => {
                        Get.to(const LeaveGroupPageWidget(), arguments: {"groupId": group.id, "groupName": group.name})
                      }, child: const Text("책방나가기", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB),))
                    ],),
                ],
              ),
            ),
          )
      );
    }

    if(groupController.groups.groups.length < 4) {
      widgets.add(
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              Get.to(const CreateBookStoreNameWidget());
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: COLOR_SUB)),
              backgroundColor: Colors.white,
              shadowColor: Colors.transparent,
            ),
            child: const Text(
              "+ 책방 추가하기",
              style: TextStyle(
                  fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB),
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  Widget getMemberLabel(bool isOwner) {
    return isOwner ? Container(
      width: 50,
      height: 20,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: COLOR_BOOK5,
      ),
      child: const Align(
        alignment: Alignment.center,
        child: Text(
          "Owner",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: FONT_APPLESD,
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      ),
    ) : Container(
      width: 50,
      height: 20,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: const Align(
        alignment: Alignment.center,
        child: Text(
          "member",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: FONT_APPLESD,
            fontSize: 10,
            color: Colors.brown,
          ),
        ),
      ),
    );
  }

  void changeRepresentGroup(Group group) {
    Alert.confirmDialog(context, "", "아래 책방을 대표책방으로 변경할까요?\n${group.name}", "변경", () async {
      await GroupService.changeRepresentation(group.id);
      await GroupService.getGroupList();
      setState(() {
        Alert.alertDialog("${group.name}을(를)\n대표책방으로 변경했어요!");
      });
    });
  }

  //TODO
   List<Widget> getEmptyWidget() {
    List<Widget> widgets = [];

    widgets.add(const Text("이용중인 책방이 없어요."));
    // widgets.add(Text("이용중인 책방이 없어요."));

    return widgets;
   }
}
