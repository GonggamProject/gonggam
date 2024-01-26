
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gonggam/common/admob/admob.dart';
import 'package:gonggam/common/notification.dart';
import 'package:gonggam/controller/invite_controller.dart';
import 'package:gonggam/ui/bookstore/invite/invited_page.dart';
import 'package:gonggam/ui/common/alert.dart';
import 'package:gonggam/ui/walkthrought_page.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:uni_links/uni_links.dart';

import '../common/constants.dart';
import '../common/prefs.dart';
import '../controller/group_controller.dart';
import '../domain/group/group.dart';
import '../domain/group/groups.dart';
import '../main.dart';
import '../service/auth/auth_factory.dart';
import '../service/group/group_service.dart';
import '../utils.dart';
import 'bookstore/bookstore_main.dart';
import 'createBookstore/create_bookstore_main_page.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  bool _initialURILinkHandled = false;
  StreamSubscription? _streamSubscription;
  bool canUpdate = false;
  Uri? scheme;

  @override
  void initState() {
    loadAd();
    _incomingLinkHandler();
    _initURIHandler();

    Timer(const Duration(milliseconds: 1500), navigateToNextScreen);
  }

  void navigateToNextScreen() async {
    final version = await Utils.appVersionCheck();
    if(version!.canUpdate) {
      Utils.showUpdateDialog(version);
      return;
    }

    if(Prefs.isLogined()) {
      try {
        Groups groups = await GroupService.getGroupList();
        if(groups.groups.isNotEmpty) {
          if(!Get.isRegistered<GroupController>()) {

            Group? group = groups.groups.firstWhereOrNull((element) => element.isRepresentation);
            group ??= groups.groups.first;
            Get.put(GroupController(groups, group.copyWith()), permanent: true);
          }
          Get.off(const BookStoreMainWidget(), arguments: {"isRefresh": false}, transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 1500));
        } else {
          Get.off(const CreateBookStoreMainWidget(), transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 1500));
        }
      } catch (e) {
        AuthFactory.createAuthService(Prefs.currentLoginedPlatform()).logout();
      }
    } else {
      Get.off(const WalkthroughtWidget(), transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 1500));
    }
  }

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
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 135,),
                  const Text("공감", style: TextStyle(color: COLOR_BOOK5,
                      fontFamily: FONT_NANUMMYNGJO,
                      fontSize: 62),),
                  const SizedBox(height: 3,),
                  const Text("책방", style: TextStyle(color: COLOR_BOOK5,
                      fontFamily: FONT_NANUMMYNGJO,
                      fontSize: 62),),
                  const SizedBox(height: 14,),
                  const Text("공유하는 감사일기", style: TextStyle(color: COLOR_SUB,
                      fontFamily: FONT_NANUMMYNGJO,
                      fontSize: 14),),
                  const Expanded(child: SizedBox.shrink()),
                  Image.asset(logoImage, width: 255, height: 202,),
                  const SizedBox(height: 84,),
                ],
              )
            ],
          ),
        )
    );
  }

  void schemeProcessor(Uri uri) {
    String? type = uri.queryParameters['type'];
    if (type != 'invite') {
      return;
    }

    String? inviteCode = uri.queryParameters['code']!;
    String? inviterName = uri.queryParameters['inviter']!;
    String? groupName = uri.queryParameters['groupName']!;
    int? groupId = int.parse(uri.queryParameters['groupId']!);

    if (Get.isRegistered<InviteController>()) {
      Get.delete<InviteController>(force: true);
    }
    Get.put(InviteController(inviteCode, inviterName, groupName, groupId), permanent: true);

    if (Prefs.isLogined()){
      Get.off(const InvitedPage());
    } else {
      Timer(const Duration(milliseconds: 1500), navigateToNextScreen);
    }
  }

  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      final uri = await getInitialUri();

      if (uri != null) {
        scheme = uri;
        schemeProcessor(uri);
      }
    }
  }

  void _incomingLinkHandler() {
    if (!kIsWeb) {
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        scheme = uri;
        schemeProcessor(uri!);
      });
    }
  }
}
