import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gonggam/domain/group/group.dart';
import 'package:gonggam/service/group/group_service.dart';
import 'package:gonggam/ui/common/alert.dart';
import '../../common/constants.dart';

class MemberManagementPageWidget extends StatefulWidget {
  const MemberManagementPageWidget({super.key});

  @override
  State<MemberManagementPageWidget> createState() => _MemberManagementPageWidgetState();
}

class _MemberManagementPageWidgetState extends State<MemberManagementPageWidget> {
  Group group = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("멤버관리", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18),),
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
              children: getMemberManagementWidgets()
          )
      ),
    );
  }

  List<Widget> getMemberManagementWidgets() {
    List<Widget> widgets = [];
    widgets.addAll(getManagementHeadWidgets());
    widgets.addAll(getMemberWidgets());

    return widgets;
  }

  List<Widget> getManagementHeadWidgets() {
    return [
      const SizedBox(height: 40,),
      const Text("책방명", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15),),
      const SizedBox(height: 10,),
      Text(group.name, style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 27, fontWeight: FontWeight.bold),),
      const SizedBox(height: 38,),
      const Divider(thickness: 1.5, height: 1, color: COLOR_LIGHTGRAY),
      const SizedBox(height: 38,),
    ];
  }

  List<Widget> getMemberWidgets() {
    List<Widget> widgets = [];

    for(var member in group.members) {
      widgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(member.profileImage)
                      )
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: member.rule.isOwner() ? COLOR_BOOK5 : const Color(0xFFE1E1E1),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          member.rule.isOwner() ? "Owner" : "Member",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: FONT_APPLESD,
                            fontSize: 10,
                            color: member.rule.isOwner() ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Text(member.nickname, style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: COLOR_SUB1),)
                  ],),
              ],),
              member.rule.isOwner() ? const SizedBox.shrink() :
              GestureDetector(
                onTap: () {
                  Alert.confirmDialog("${member.nickname}을 내보낼까요?", "내보내면 ${member.nickname}님의\n글은 삭제됩니다.", "내보내기", () => {
                    GroupService.kickOutMember(group.id, member.customerId)
                  });
                  setState(() {
                    group.members.removeWhere((element) => element.customerId == member.customerId);
                  });
                },
                child: Container(
                  width: 50,
                  height: 25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text("내보내기",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FONT_APPLESD,
                        fontSize: 10,
                        color: Colors.black
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
      );
      widgets.add(const SizedBox(height: 40));
    }
    return widgets;
  }
}
