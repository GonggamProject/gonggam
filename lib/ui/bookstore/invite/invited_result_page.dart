import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gonggam/ui/createBookstore/create_bookstore_main_page.dart';

import '../../../common/constants.dart';

class InvitedResultPage extends StatefulWidget {
  const InvitedResultPage({super.key});

  @override
  State<InvitedResultPage> createState() => _InvitedResultPageState();
}

class _InvitedResultPageState extends State<InvitedResultPage> {
  String resCode = Get.arguments;

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
                    children: resCode == "GG2000" ? getError2Widgets() : getError1Widgets()
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 60,
                  child: ElevatedButton(onPressed: () async {
                    Get.offAll(const CreateBookStoreMainWidget());
                  },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: COLOR_BOOK5,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text("확인",
                      style: TextStyle(
                          fontFamily: FONT_APPLESD, fontSize: 18),),
                  ),)
              ],
            )
        )
    );
  }

  List<Widget> getError1Widgets() {
    return [
      const SizedBox(height: 130,),
      const Text("책방에 인원이 꽉 찼거나",
        style: TextStyle(fontFamily: FONT_APPLESD,
            fontSize: 21,
            color: COLOR_BOOK5,
            fontWeight: FontWeight.bold),),
      const SizedBox(height: 5,),
      const Text("초대 링크가 만료되었어요.",
        style: TextStyle(fontFamily: FONT_APPLESD,
            fontSize: 21,
            color: COLOR_BOOK5,
            fontWeight: FontWeight.bold),),
      Image.asset(
        "$IMAGE_PATH/invite_fail_image.png", width: 227,
        height: 207,),
      const SizedBox(height: 20,)
    ];
  }

  List<Widget> getError2Widgets() {
    return [
      const SizedBox(height: 130,),
      const Text("이미 책방을 4개나",
        style: TextStyle(fontFamily: FONT_APPLESD,
            fontSize: 21,
            color: COLOR_BOOK5,
            fontWeight: FontWeight.bold),),
      const SizedBox(height: 5,),
      const Text("이용중이에요.",
        style: TextStyle(fontFamily: FONT_APPLESD,
            fontSize: 21,
            color: COLOR_BOOK5,
            fontWeight: FontWeight.bold),),
      Image.asset(
        "$IMAGE_PATH/invite_fail_image.png", width: 227,
        height: 207,),
      const SizedBox(height: 148,),
      const Text("공감책방은 최대 4개까지 참여(생성)", style: TextStyle(fontFamily: FONT_APPLESD,
          fontSize: 15,
          color: COLOR_BOOK5,)),
      const Text("가능해요. 이용하지 않는 책방이 있다면", style: TextStyle(fontFamily: FONT_APPLESD,
        fontSize: 15,
        color: COLOR_BOOK5,)),
      const Text("설정 > 책방관리에서 책방을 삭제하거나", style: TextStyle(fontFamily: FONT_APPLESD,
        fontSize: 15,
        color: COLOR_BOOK5,)),
      const Text("책방 떠가기를 진행해주세요.", style: TextStyle(fontFamily: FONT_APPLESD,
        fontSize: 15,
        color: COLOR_BOOK5,)),
    ];
  }

}
