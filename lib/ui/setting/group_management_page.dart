import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: getGroupManagementWidgets()
              ),
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
          Text(groupController.groups.groups.length.toString(), style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_BLUE, fontWeight: FontWeight.bold),),
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
                            const SizedBox(width: 5,),
                            isOwner ? InkWell(
                              child: const Icon(Icons.edit, size: 15, color: COLOR_SUB,),
                              onTap: () => {
                                changeGroupNameModal(context, group.id, group.name, () {
                                  setState(() {
                                  });
                                })
                            },) : const SizedBox.shrink()
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
    Alert.confirmDialog("", "아래 책방을 대표책방으로 변경할까요?\n${group.name}", "변경", () async {
      await GroupService.changeRepresentation(group.id);
      await GroupService.getGroupList();
      setState(() {
        Alert.alertDialog("${group.name}을(를)\n대표책방으로 변경했어요!");
      });
    });
  }

  Future changeGroupNameModal(BuildContext context, int groupId, String currentGroupName, Function() callback) {
    String groupName = "";

    return showModalBottomSheet(
      isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter bottomState) {
              return Padding(
                  padding: EdgeInsets.fromLTRB(30, 20, 30, MediaQuery.of(context).viewInsets.bottom + 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text("책방이름 수정", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB1),),
                        const SizedBox(height: 5,),
                        SizedBox(
                          child: TextField(
                            maxLength: MAX_GROUPNAME_LENGTH,
                            decoration: InputDecoration(
                              suffix: RichText(text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: groupName.length.toString(),
                                        style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 12, color: COLOR_BOOK4, fontWeight: FontWeight.bold)
                                    ),
                                    const TextSpan(
                                        text: " / ",
                                        style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 12, color: COLOR_SUB, fontWeight: FontWeight.bold)
                                    ),
                                    TextSpan(
                                        text: MAX_GROUPNAME_LENGTH.toString(),
                                        style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 12, color: COLOR_SUB, fontWeight: FontWeight.bold)
                                    ),
                                  ]
                              ),),
                              contentPadding: const EdgeInsets.all(20),
                              counterText: "",
                              hintText: currentGroupName,
                              hintStyle: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: Color(0xFFB4B4B4),),
                              filled: true,
                              fillColor: const Color(0xFFF2F2F2),
                              border: InputBorder.none,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFF2F2F2),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder:  const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFF2F2F2),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              errorBorder:  const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFF2F2F2),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10)),

                              ),
                              focusedErrorBorder:  const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFF2F2F2),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣]")),
                            ],
                            onChanged: (value) {
                              bottomState(() {
                                setState(() {
                                  groupName = value;
                                });
                              });
                            },
                            cursorRadius: const Radius.circular(5),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        const Text("책방이름은 최대 10자까지 작성할 수 있어요.", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 12, color: Colors.blue),),
                        const SizedBox(height: 10,),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(onPressed: () {
                            Navigator.pop(context);
                            Alert.confirmDialog("", "책방이름을 $groupName(으)로 수정할까요?", "수정하기", () {
                              try {
                                GroupService.groupNameChange(groupId, groupName).then((value) {
                                  callback();
                                });
                              } catch (e) {
                                Alert.alertDialog("책방이름 수정 중 오류가 발생했어요.\n잠시 후 다시 시도해 주세요.");
                              }
                            });
                          },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: groupName.isNotEmpty ? COLOR_BOOK5 : const Color(0xFFCDCDCD),
                              shadowColor: Colors.transparent,
                            ),
                            child: const Text("수정하기", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18),),
                          ),),
                      ]));
            },
          );
        });
  }
}


