import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gonggam/common/constants.dart';
import 'package:gonggam/controller/invite_controller.dart';
import 'package:gonggam/service/customer/customer_service.dart';
import 'package:gonggam/ui/bookstore/invite/invited_page.dart';
import 'package:gonggam/ui/createBookstore/create_bookstore_main_page.dart';

class CreateNicknameWidget extends StatefulWidget {
  const CreateNicknameWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CreateNicknameWidgetState();
}

class _CreateNicknameWidgetState extends State<CreateNicknameWidget> {
  final int maxLength = 10;
  String nickname = Get.arguments ?? "";
  int nicknameLength = 0;
  late TextEditingController textEditingController;

  final String nicknameLengthGuide = "닉네임은 최대 10자까지 작성할 수 있어요.";
  final String nicknameExistGuide = "이미 사용중인 닉네임이에요.";
  String guideText = "";


  @override
  void initState() {
    if(nickname.isNotEmpty) {
      nicknameLength = nickname.length;
      textEditingController = TextEditingController(text: nickname);
    } else {
      textEditingController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "공감책방",
          style: TextStyle(fontFamily: FONT_NANUMMYNGJO, fontSize: 15),
        ),
        foregroundColor: Colors.black,
        backgroundColor: COLOR_BACKGROUND,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
            minimum: PADDING_MINIMUM_SAFEAREA,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 57,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "공감책방에서 사용할",
                        style: TextStyle(
                            fontFamily: FONT_APPLESD,
                            fontSize: 18,
                            color: COLOR_SUB),
                      ),
                      const Text(
                        "닉네임을 적어주세요.",
                        style: TextStyle(
                            fontFamily: FONT_APPLESD,
                            fontSize: 18,
                            color: COLOR_SUB),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsetsDirectional.fromSTEB(8, 100, 8, 0),
                            child: TextField(
                              maxLength: 10,
                              controller: textEditingController,
                              decoration: InputDecoration(
                                suffix: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: nicknameLength.toString(),
                                        style: const TextStyle(
                                            fontFamily: FONT_APPLESD,
                                            fontSize: 12,
                                            color: COLOR_BOOK4,
                                            fontWeight: FontWeight.bold)),
                                    const TextSpan(
                                        text: " / ",
                                        style: TextStyle(
                                            fontFamily: FONT_APPLESD,
                                            fontSize: 12,
                                            color: COLOR_SUB,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: maxLength.toString(),
                                        style: const TextStyle(
                                            fontFamily: FONT_APPLESD,
                                            fontSize: 12,
                                            color: COLOR_SUB,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                                ),
                                contentPadding: const EdgeInsets.all(20),
                                counterText: "",
                                hintText: "닉네임",
                                hintStyle: const TextStyle(
                                  fontFamily: FONT_APPLESD,
                                  fontSize: 15,
                                  color: Color(0xFFB4B4B4),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF2F2F2),
                                border: InputBorder.none,
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFF2F2F2),
                                    width: 1,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFF2F2F2),
                                    width: 1,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFF2F2F2),
                                    width: 1,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFF2F2F2),
                                    width: 1,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              autofocus: true,
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣]")),
                              ],
                              onChanged: (nickname) {
                                setState(() {
                                  this.nickname = nickname;
                                  nicknameLength = nickname.length;
                                  guideText = nickname.length == MAX_NICKNAME_LENGTH ? nicknameLengthGuide : "";
                                });
                              },
                              cursorRadius: const Radius.circular(10),
                            ),
                          ),
                          Positioned(
                              top: 12,
                              child: Image.asset("$IMAGE_PATH/nickname_input_logo.png", width: 112, height: 110,)
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 5,),
                      Text(
                        guideText,
                        style: const TextStyle(
                            fontFamily: FONT_APPLESD,
                            fontSize: 12,
                            color: COLOR_BLUE),
                      )
                    ],
                  ),
                ],
              ),
            )),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 30, right: 30, bottom: 32),
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            nicknameLength > 0
                ? nicknameUpdate(nickname)
                : null;
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              shadowColor: Colors.transparent,
              backgroundColor: nicknameLength > 0
                  ? COLOR_BOOK5
                  : const Color(0xFFCDCDCD)),
          child: const Text(
            "확인",
            style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18),
          ),
        ),
      )
    );
  }

  Future<dynamic>? nicknameUpdate(nickname) {
    CustomerService().updateCustomerNickname(nickname);

    if(Get.isRegistered<InviteController>()) {
      Get.off(const InvitedPage());
    } else {
      Get.off(const CreateBookStoreMainWidget());
    }
  }
}
