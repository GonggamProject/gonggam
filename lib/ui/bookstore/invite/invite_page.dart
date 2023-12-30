import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gonggam/controller/group_controller.dart';
import 'package:gonggam/service/customer/customer_service.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';

import '../../../common/constants.dart';
import '../../../domain/customer/customer_info.dart';
import '../../../service/group/group_service.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key});

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("초대하기", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18),),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 65,),
                  const Text("공감책방에", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 21, color: COLOR_BOOK5, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 5,),
                  const Text("친구들을 초대해보세요!", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 21, color: COLOR_BOOK5, fontWeight: FontWeight.bold),),
                  Image.asset("$IMAGE_PATH/invite_image.png", width: 227, height: 207,),
                  const SizedBox(height: 20,),
                  const Text("공감책방을 통해 친구들과", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: COLOR_SUB),),
                  const SizedBox(height: 5,),
                  const Text("감사일기를 공유해보세요.", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: COLOR_SUB),),
                  const SizedBox(height: 5,),
                  const Text("최대 5명이 함께 공유할 수 있어요.", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: COLOR_SUB),),
                  const SizedBox(height: 30,),
                  SizedBox(
                    width: 189,
                    height: 53,
                    child: InkWell(onTap: () {
                        inviteKakaotalk();
                      }, 
                      child: Image.asset("$IMAGE_PATH/button_invite_kakao.png"),
                    ),),
                  const SizedBox(height: 15),
                ],
              ),
            ],
          )
      )
    );
  }

  void inviteKakaotalk() async {
    GroupController groupController = Get.find();
    String inviteCode = await GroupService.getGroupInviteCode(groupController.group.id);
    CustomerInfo customerInfo = await CustomerService().getCustomerInfo();
    bool isKakaotalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();

    int templateId = 97112;
    Map<String, String> args = {
      'type': 'invite',
      'code': inviteCode,
      'groupName': groupController.group.name,
      'groupId' : groupController.group.id.toString(),
      'inviter': customerInfo.nickname};

    if(isKakaotalkSharingAvailable) {
      Uri uri = await ShareClient.instance.shareCustom(templateId: templateId, templateArgs: args);
      await ShareClient.instance.launchKakaoTalk(uri);
    } else {
      try {
        Uri shareUrl = await WebSharerClient.instance.makeCustomUrl(templateId: templateId, templateArgs: args);
        await launchBrowserTab(shareUrl, popupOpen: true);
      } catch (error) {
        print('카카오톡 공유실패 $error');
      }
    }
  }
}