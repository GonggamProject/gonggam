import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gonggam/ui/setting/setting_page.dart';
import '../../common/constants.dart';
import '../../common/prefs.dart';
import '../../controller/group_controller.dart';
import '../../domain/group/groups.dart';
import '../../service/group/group_service.dart';
import '../common/alert.dart';
import '../createBookstore/create_bookstore_main_page.dart';

class LeaveGroupPageWidget extends StatefulWidget {
  const LeaveGroupPageWidget({super.key});

  @override
  State<LeaveGroupPageWidget> createState() => _LeaveGroupPageWidgetState();
}

class _LeaveGroupPageWidgetState extends State<LeaveGroupPageWidget> {
  bool leaveCheck = false;

  final int groupId = Get.arguments["groupId"];
  final String groupName = Get.arguments["groupName"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: COLOR_BACKGROUND,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "책방나가기", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18),),
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
              children: [
                const SizedBox(height: 40,),
                const Text("이용중인 책방",
                  style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15),),
                const SizedBox(height: 10,),
                Text(groupName, style: const TextStyle(fontFamily: FONT_APPLESD,
                    fontSize: 27,
                    fontWeight: FontWeight.bold),),
                const SizedBox(height: 38,),
                const Divider(
                    thickness: 1.5, height: 1, color: COLOR_LIGHTGRAY),
                const SizedBox(height: 38,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• "),
                    Expanded(child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          RichText(text: TextSpan(children: [
                            TextSpan(text: '이용중인 책방을 떠나면 "${Prefs
                                .getCustomerName()}"님이 작성했던 ',
                                style: const TextStyle(fontFamily: FONT_APPLESD,
                                    fontSize: 15,
                                    color: COLOR_SUB)),
                            const TextSpan(text: "모든 내용은 즉시 삭제됩니다. ",
                                style: const TextStyle(fontFamily: FONT_APPLESD,
                                    fontSize: 15,
                                    color: COLOR_BOOK4))
                          ]))
                        ]),)
                  ],),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• "),
                    Expanded(child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        spacing: 5,
                        runSpacing: 2,
                        children: [
                          Text(
                            '"$groupName" 책방 이 계속 운영 중이라면 책방에 다시 참여할 수 있습니다.',
                            style: TextStyle(fontFamily: FONT_APPLESD,
                                fontSize: 15,
                                color: COLOR_SUB),),
                          RichText(text: TextSpan(children: [
                            TextSpan(
                                text: '단, "$groupName" 책방 나가기 후 다시 참여할 경우, ',
                                style: const TextStyle(fontFamily: FONT_APPLESD,
                                    fontSize: 15,
                                    color: COLOR_SUB)),
                            const TextSpan(text: "과거에 작성 된 내용 복구 되지 않습니다.",
                                style: const TextStyle(fontFamily: FONT_APPLESD,
                                    fontSize: 15,
                                    color: COLOR_BOOK4))
                          ])),
                        ]),)
                  ],),
                const SizedBox(height: 50,),
                InkWell(child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Checkbox(
                        value: leaveCheck,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        activeColor: Colors.white,
                        checkColor: Colors.black,
                        side: MaterialStateBorderSide.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return const BorderSide(
                                  width: 1, color: Colors.black);
                            }
                            return const BorderSide(width: 1,
                                color: Colors.black);
                          },
                        ),
                        onChanged: (value) {
                          setState(() {
                            leaveCheck = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        spacing: 5,
                        runSpacing: 2,
                        children: [
                          Text('유의사항을 확인했으며, "$groupName" 책방 나가기에 동의합니다.')
                        ]),)

                  ],
                ), onTap: () {
                  setState(() {
                    leaveCheck = !leaveCheck;
                  });
                },),
              ]
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(left: 30, right: 30, bottom: 32),
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              if (leaveCheck) {
                Alert.confirmDialog("", "$groupName을(를) 정말로 나갈까요?", "책방 나가기", () => {
                  leaveAction()
                });
              }
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                        color: leaveCheck ? Colors.transparent : Colors.black)
                ),
                shadowColor: Colors.transparent,
                backgroundColor: leaveCheck ? COLOR_BOOK5 : const Color(
                    0xFFFFFFFF)),
            child: Text(
              "책방 나가기",
              style: TextStyle(fontFamily: FONT_APPLESD,
                  fontSize: 18,
                  color: leaveCheck ? Colors.white : Colors.black),
            ),
          ),
        )
    );
  }

  void leaveAction() {
    try {
      GroupService.leaveGroup(groupId);
      Alert.alertActionDialog("책방 나가기 완료", "책방 나가기가 완료되었어요!\n다시 또 놀러오세요!", () => {
        movePage()
      });
    } catch (err) {
      Alert.alertDialog("책방 나가기 중 오류가 발생했어요.\n잠시 후 다시 시도해주세요.");
    }
  }

  Future<void> movePage() async {
    Groups groups = await GroupService.getGroupList();
    if (groups.groups.isEmpty) {
      Get.delete<GroupController>();
      Get.offAll(const CreateBookStoreMainWidget());
    } else {
      Get.find<GroupController>().resetGroup();
      Get.offAll(const SettingPageWidget());
    }
  }
}