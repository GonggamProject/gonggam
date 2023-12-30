import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gonggam/common/constants.dart';
import 'package:gonggam/service/auth/auth_factory.dart';

import 'common/alert.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<StatefulWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {

  @override
  Widget build(BuildContext context) {
    const String logoImage = "$IMAGE_PATH/splash_logo.png";

    return Scaffold(
        backgroundColor: COLOR_SPLASH_BACKGROUND,
        body: SafeArea(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Expanded(child:
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        const Text("공감", style: TextStyle(color: COLOR_BOOK5,
                            fontFamily: FONT_NANUMMYNGJO,
                            fontSize: 62),),
                        const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                        const Text("책방", style: TextStyle(color: COLOR_BOOK5,
                            fontFamily: FONT_NANUMMYNGJO,
                            fontSize: 62),),
                        const Padding(padding: EdgeInsets.fromLTRB(0, 14, 0, 0)),
                        const Text("공유하는 감사일기", style: TextStyle(color: COLOR_SUB,
                            fontFamily: FONT_NANUMMYNGJO,
                            fontSize: 14),),
                        const Padding(padding: EdgeInsets.fromLTRB(0, 67, 0, 0)),
                        Image.asset(logoImage, width: 255, height: 202,),
                      ],),
                    )
                  ),
                  Column(children: [
                    SizedBox(
                        height: 54,
                        width: 339,
                        child: InkWell(
                            onTap: () {
                              AuthFactory.createAuthService("kakao").login();
                            },
                            child: Image.asset("$IMAGE_PATH/login_button_kakao.png"),
                        )
                    ),
                    const SizedBox(height: 10,),
                    Platform.isIOS ? SizedBox(
                        height: 54,
                        width: 339,
                        child: InkWell(
                            onTap: () {
                                AuthFactory.createAuthService("apple").login();
                            },
                            child: Image.asset("$IMAGE_PATH/login_button_apple.png",),
                        )
                    ) : const SizedBox.shrink()
                  ],)
                ],
              ),
            ],
          ),
        )
    );
  }
}
