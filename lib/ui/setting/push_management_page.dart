import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gonggam/domain/setting/pushes_get.dart';
import 'package:gonggam/domain/setting/pushes_update.dart';
import 'package:gonggam/service/setting/setting_service.dart';
import '../../common/constants.dart';
import '../../utils.dart';

class PushManagementPageWidget extends StatefulWidget {
  const PushManagementPageWidget({super.key});

  @override
  State<PushManagementPageWidget> createState() => _PushManagementPageWidgetState();
}

class _PushManagementPageWidgetState extends State<PushManagementPageWidget> {
  bool _isDailyPush = false;
  int _dailyPushTime = 19;
  bool _isMemberNewNotePush = false;

  @override
  void initState() {
    getPushData();
  }

  void getPushData() async {
    PushesGet pushesGet = await SettingService.getPushes();
    setState(() {
      _isMemberNewNotePush = pushesGet.isNoticeMemberNewNote;
      _dailyPushTime = pushesGet.hourForRemind ?? 19;
      if (_dailyPushTime != null) {
        _isDailyPush = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("알림설정", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18),),
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
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25,),
                  getDailyPushWidget(),
                  const SizedBox(height: 30,),
                  getNoticeMemberNewNoteWidget()
                ]
            ),
          )
      ),
    );
  }

  Widget getDailyPushWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("감사일기 작성 알림", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: COLOR_SUB),),
                SizedBox(height: 5,),
                Text("매일 감사일기 작성을 까먹지 않도록 알려드려요", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 12, color: COLOR_GRAY),)
              ],
            ),
            CupertinoSwitch(
                activeColor: COLOR_BOOK5,
                value: _isDailyPush,
                onChanged: (bool? value) {
                  setState(() {
                    _isDailyPush = value ?? false;
                    setPushData();
                  });
                }
            )
          ],
        ),
        _isDailyPush ? const SizedBox(height: 15,) : const SizedBox.shrink(),
        _isDailyPush ? Container(
          height: 40,
          width: double.infinity,
          padding: const EdgeInsets.only(left: 20, right: 20),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(28)),
            ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(text: TextSpan(text: "알림시간 : ",
                  style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 12),
                  children: [
                TextSpan(text: Utils.dailyPushText(_dailyPushTime), style: const TextStyle(fontFamily: FONT_APPLESD, fontWeight: FontWeight.bold, fontSize: 12))
              ])),
              InkWell(onTap: () {
                showDailyPushTimeModal(context, _dailyPushTime, (dailyPushTime) {
                  setState(() {
                    _dailyPushTime = dailyPushTime;
                    setPushData();
                  });
                });
              }, child: const Text("알림수정", style: TextStyle(color: Color(0xFFEFEFEF), fontFamily: FONT_APPLESD, fontSize: 9),),)
            ],
          )
        ) : const SizedBox.shrink()
      ],
    );
  }

  Widget getNoticeMemberNewNoteWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("멤버 새글 알림", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: COLOR_SUB),),
            SizedBox(height: 5,),
            Text("멤버가 감사일기를 작성하면 알려드려요", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 12, color: COLOR_GRAY),)
          ],
        ),
        CupertinoSwitch(
            activeColor: COLOR_BOOK5,
            value: _isMemberNewNotePush,
            onChanged: (bool? value) {
              setState(() {
                _isMemberNewNotePush = value ?? false;
                setPushData();
              });
            }
        )
      ],
    );
  }

  Future showDailyPushTimeModal(BuildContext context, int dailyPushTime, Function(int dailyPushTime) changeDailyPushTime) {
    final midday = ["오전", "오후"];

    int initMidday = dailyPushTime < 12 ? 0 : 1;
    int initTime = dailyPushTime == 0 || dailyPushTime == 12 ? 11 : (dailyPushTime % 12) - 1;

    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter bottomState) {
              return SizedBox(
                height: 330,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 40, 30, 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text("알림 시간을 설정해 주세요.", style: TextStyle(fontFamily: FONT_APPLESD, fontWeight: FontWeight.bold, fontSize: 18),),
                        const SizedBox(height: 25,),
                        Row(
                          children: [
                            Expanded(child: SizedBox(
                              height: 150,
                              child: CupertinoPicker.builder(
                                  scrollController: FixedExtentScrollController(initialItem: initMidday),
                                  itemExtent: 50,
                                  childCount: 2,
                                  onSelectedItemChanged: (i) {
                                    setState(() {
                                      initMidday = i;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return Center(
                                      child: Text(
                                        midday[index],
                                      ),
                                    );
                                  }),
                            )),
                            Expanded(child: SizedBox(
                              height: 150,
                              child: CupertinoPicker.builder(
                                  scrollController: FixedExtentScrollController(initialItem: initTime),
                                  itemExtent: 50,
                                  childCount: 12,
                                  onSelectedItemChanged: (i) {
                                    setState(() {
                                      initTime = i;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return Center(
                                      child: Text(
                                        "${index + 1}시",
                                      ),
                                    );
                                  }),
                            )),
                          ],
                        ),
                        Row(children: [
                          Expanded(child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 5, 10),
                            height: 60,
                            child: ElevatedButton(onPressed: () {
                              Navigator.pop(context);
                            },
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                    color: COLOR_SUB,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: Colors.white,
                                  shadowColor: Colors.transparent
                              ),
                              child: const Text("취소", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: Colors.black),),
                            ),
                          ),),
                          Expanded(child: Container(
                            padding: const EdgeInsets.fromLTRB(5, 0, 10, 10),
                            height: 60,
                            child: ElevatedButton(onPressed: () {
                              int time = initMidday * 12 + (initTime + 1);
                              if (initTime == 11) {
                                time -= 12;
                              }

                              changeDailyPushTime(time);
                              Navigator.pop(context);
                            },
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(
                                    color: COLOR_SUB,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: COLOR_BOOK5,
                                  shadowColor: Colors.transparent
                              ),
                              child: const Text("알림 설정", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: Colors.white),),
                            ),
                          ),),
                        ],)
                      ],
                    )
                ),
              );
            },
          );
        });
  }

  void setPushData() {
    SettingService.postPushes(PushesUpdate(_isMemberNewNotePush, _isDailyPush ? _dailyPushTime : null));
  }
}


