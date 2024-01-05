import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gonggam/controller/group_controller.dart';
import 'package:gonggam/service/customer/customer_service.dart';
import 'package:gonggam/service/setting/setting_service.dart';
import 'package:gonggam/ui/common/bottom_navigation_bar.dart';
import 'package:gonggam/ui/createBookstore/create_bookstore_name_page.dart';
import 'package:gonggam/ui/setting/group_management_page.dart';
import 'package:gonggam/ui/setting/secession_page.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/constants.dart';
import 'package:get/get.dart';

import '../common/alert.dart';

class SettingPageWidget extends StatefulWidget {
  const SettingPageWidget({super.key});

  @override
  State<SettingPageWidget> createState() => _SettingPageWidgetState();
}

class _SettingPageWidgetState extends State<SettingPageWidget> {
  late GroupController? groupController;
  String appVersion = "0.0.0";
  final InAppReview inAppReview = InAppReview.instance;

  @override
  void initState() {
    super.initState();

    if(Get.isRegistered<GroupController>()) {
      groupController = Get.find<GroupController>();
    } else {
      groupController = null;
    }

    getAppVersion();
  }

  void getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "설정",
          style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: COLOR_SUB),
        ),
        foregroundColor: Colors.black,
        backgroundColor: COLOR_BACKGROUND,
        elevation: 0,
        leading: const SizedBox.shrink(),
      ),
      body: SafeArea(
          minimum: PADDING_MINIMUM_SAFEAREA,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: CustomerService().getCustomerInfo(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              margin: const EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: CachedNetworkImageProvider(snapshot.data!.profileImage)
                                )
                              ),
                            ),
                            Text(snapshot.data!.nickname)
                          ],
                        );
                      } else {
                        return const Center(child: SizedBox(width: 10, height: 10, child: CircularProgressIndicator(),));
                      }
                    }),
                const SizedBox(height: 35,),
                const Divider(thickness: 1.5, height: 1, color: COLOR_LIGHTGRAY),
                Container(
                    margin: const EdgeInsets.only(top: 32, bottom: 30),
                    child: const Text("설정", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, fontWeight: FontWeight.bold),)),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 27,
                  child: InkWell(
                    onTap: () => {
                      if (groupController == null || groupController!.groups.groups.isEmpty) {
                        Alert.confirmDialog(context, "", "이용중인 책방이 없어요.\n책방을 새로 만들까요?", "책방 만들기", () => {
                          Get.to(const CreateBookStoreNameWidget())
                        })
                      } else {
                        Get.to(const GroupManagementPageWidget(), duration: const Duration(seconds: 0))
                      }
                    },
                    child: Row(mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        const Text("책방관리"),
                        Row(children: [
                          groupController == null ?
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: "0",
                                  style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_BLUE),
                                ),
                                TextSpan(
                                  text: "개",
                                  style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB),
                                ),
                              ],
                            ),
                          ) :
                          Obx(() => RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${groupController?.groupCount ?? 0}",
                                  style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_BLUE),
                                ),
                                const TextSpan(
                                  text: "개",
                                  style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB),
                                ),
                              ],
                            ),
                          )),
                          const Icon(Icons.keyboard_arrow_right),
                        ],)
                      ],),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 30),
                    child: const Text("앱정보", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, fontWeight: FontWeight.bold),)),
                getBrowserWidget("이용약관", LINK_TERMS),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 27,
                  child:  InkWell(
                    onTap: () => {
                      SettingService().sendEmail(context)
                    },
                    child: const Row(mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        Text("공감책방에 의견을 남겨주세요"),
                        Icon(Icons.keyboard_arrow_right),
                      ],),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 27,
                  child: InkWell(
                    onTap: () => {
                      requestReview()
                    },
                    child:
                    const Row(mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      Text("공감책방에 별점남기기"),
                      Icon(Icons.keyboard_arrow_right),
                    ],),),
                ),
                getBrowserWidget("공감책방 사람들", LINK_MAKERS),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  height: 27,
                  child: InkWell(onTap: () {
                    if (groupController != null && groupController!.groups.groups.isNotEmpty) {
                      Alert.alertDialog("이용중인 책방이 있어요.\n책방을 삭제하거나 떠난 후 탈퇴가 가능해요.");
                    } else {
                      Get.to(const SecessionPageWidget());
                    }
                  }, child: const Text("탈퇴하기", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_GRAY, decoration: TextDecoration.underline),)
                ),),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("공감책방", style: TextStyle(fontFamily: FONT_NANUMMYNGJO, fontSize: 12, color: COLOR_BOOK3),),
                    Text("Version $appVersion", style: const TextStyle(fontFamily: FONT_SFPRO, fontSize: 12, color: COLOR_BOOK3),)
                  ],
                ),
              ],
            ),
          )),
        bottomNavigationBar: getBottomNavigationBar(context, Get.isRegistered<GroupController>() ? Get.find<GroupController>() : null)
    );
  }

  Widget getBrowserWidget(String menuTitle, String url) {
    return  Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 27,
        child: InkWell(
          onTap: () async {
            if (!await launchUrl(Uri.parse(url))) {
              throw Exception('Could not open brwoser');
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(menuTitle),
                  ],
                ),
              ),
              const Icon(Icons.keyboard_arrow_right),
            ],
          ),
        )
    );
  }

  Future<void> requestReview() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }
}

