import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gonggam/controller/group_controller.dart';
import 'package:gonggam/ui/setting/setting_page.dart';
import '../../common/constants.dart';
import '../../domain/group/groups.dart';
import '../../service/group/group_service.dart';
import '../createBookstore/create_bookstore_main_page.dart';

class RemoveGroupPageWidget extends StatefulWidget {
  const RemoveGroupPageWidget({super.key});

  @override
  State<RemoveGroupPageWidget> createState() => _RemoveGroupPageWidgetState();
}

class _RemoveGroupPageWidgetState extends State<RemoveGroupPageWidget> {
  bool removeCheck = false;

  final int groupId = Get.arguments["groupId"];
  final String groupName = Get.arguments["groupName"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("책방삭제", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18),),
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
                const Text("운영중인 책방", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15),),
                const SizedBox(height: 10,),
                Text(groupName, style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 27, fontWeight: FontWeight.bold),),
                const SizedBox(height: 38,),
                const Divider(thickness: 1.5, height: 1, color: COLOR_LIGHTGRAY),
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
                          RichText(text: const TextSpan(children: [
                            TextSpan(text: '책방 삭제 시, 책방은 모든 멤버들의 목록에서도 일괄 삭제처리 됩니다.', style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB))
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
                          RichText(text: const TextSpan(children: [
                            TextSpan(text: '운영중인 책방을 삭제하면 멤버들이 작성한 ', style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB)),
                            TextSpan(text: '모든 내용은 즉시 삭제됩니다.', style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_BOOK4)),
                          ])),
                        ]),)
                  ],),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("• "),
                    Expanded(child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        spacing: 5,
                        runSpacing: 2,
                        children: [
                          Text('삭제 처리된 책방과 글은 복구 되지 않습니다.', style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_BOOK4),),
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
                        value: removeCheck,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        activeColor: Colors.white,
                        checkColor: Colors.black,
                        side: MaterialStateBorderSide.resolveWith(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return const BorderSide(width: 1, color: Colors.black);
                            }
                            return const BorderSide(width: 1, color: Colors.black);
                          },
                        ),
                        onChanged: (value) {
                          setState(() {
                            removeCheck = value!;
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
                          Text('유의사항을 확인했으며, "$groupName" 책방 삭제에 동의합니다.')
                        ]),)

                  ],
                ), onTap: () {
                  setState(() {
                    removeCheck = !removeCheck;
                  });
                },),
              ]
          )
      ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(left: 30, right: 30, bottom: 32),
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              if (removeCheck) {
                GroupService.removeGroup(groupId).then((value) async {
                  Groups groups = await GroupService.getGroupList();
                  if (groups.groups.isEmpty) {
                    Get.delete<GroupController>();
                    Get.offAll(const CreateBookStoreMainWidget());
                  } else {
                    Get.find<GroupController>().resetGroup();
                    Get.offAll(const SettingPageWidget());
                  }
                });
              }
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: removeCheck ? Colors.transparent : Colors.black)
                ),
                shadowColor: Colors.transparent,
                backgroundColor: removeCheck ? COLOR_BOOK5 : const Color(0xFFFFFFFF)),
            child: Text(
              "책방삭제하기",
              style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: removeCheck ? Colors.white : Colors.black),
            ),
          ),
        )
    );
  }
}
