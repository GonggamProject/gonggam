import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/constants.dart';
import '../../common/prefs.dart';
import '../../service/customer/customer_service.dart';
import '../../service/group/group_service.dart';
import '../common/alert.dart';
import '../splash_page.dart';

class SecessionPageWidget extends StatefulWidget {
  const SecessionPageWidget({super.key});

  @override
  State<SecessionPageWidget> createState() => _SecessionPageWidgetState();
}

class _SecessionPageWidgetState extends State<SecessionPageWidget> {
  bool secessionCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: COLOR_BACKGROUND,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("회원탈퇴", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18),),
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
                const Text("공유하는 감사일기", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15),),
                const SizedBox(height: 10,),
                const Text("공감책방", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 27, fontWeight: FontWeight.bold),),
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
                          RichText(text: TextSpan(children: [
                            TextSpan(text: '공감 책방을 탈퇴 시 ${Prefs.getCustomerName()}님이 참여했던 모든 책방에서 일괄 떠나기 처리됩니다.', style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB)),
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
                          RichText(text: TextSpan(children: [
                            TextSpan(text: '또한 ${Prefs.getCustomerName()}님이 참여중인 책방에서 작성했던 ', style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB)),
                            const TextSpan(text: "모든 감사일기는 즉시 삭제되며 작성 된 내용은 복구 되지 않습니다.", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_BOOK4))
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
                        value: secessionCheck,
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
                            secessionCheck = value!;
                          });
                        },
                      ),
                    ),
                    const Expanded(child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        spacing: 5,
                        runSpacing: 2,
                        children: [
                          Text('유의사항을 확인했으며, 공감책방 탈퇴에 동의합니다.')
                        ]),)

                  ],
                ), onTap: () {
                  setState(() {
                    secessionCheck = !secessionCheck;
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
              if(secessionCheck) {
                try {
                  CustomerService().secession();
                  Alert.alertActionDialog("공감책방 탈퇴 완료", "다음에 또 공감책방을 이용해주세요!", () => {
                    Get.offAll(const SplashWidget())
                  });
                } catch (err) {
                  Alert.alertDialog("탈퇴 중 오류가 발생했어요.\n잠시 후 다시 시도해주세요.");
                }
              }
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: secessionCheck ? Colors.transparent : Colors.black)
                ),
                shadowColor: Colors.transparent,
                backgroundColor: secessionCheck ? COLOR_BOOK5 : const Color(0xFFFFFFFF)),
            child: Text(
              "책방탈퇴하기",
              style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: secessionCheck ? Colors.white : Colors.black),
            ),
          ),
        )
    );
  }
}
