import 'dart:collection';
import 'dart:typed_data';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:gonggam/ui/common/alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../common/constants.dart';
import '../../domain/note/note.dart';

class ShareNoteWidget extends StatefulWidget {
  const ShareNoteWidget({super.key});

  @override
  State<ShareNoteWidget> createState() => _ShareNoteWidgetState();
}

class _ShareNoteWidgetState extends State<ShareNoteWidget>{
  final _screenshotControllerList = [ScreenshotController(), ScreenshotController(), ScreenshotController(), ScreenshotController()];
  final _controller = PageController(initialPage: 0, viewportFraction:0.8);
  
  final DateTime shareDate = DateTime.parse(Get.arguments["date"]);
  final List<Note> shareData = Get.arguments["data"];

  int _currentIndex = 0;
  Map<int, Uint8List> imageMap = HashMap();

  @override
  void initState() {
    generateShareImages();
  }

  void generateShareImages() {
    _screenshotControllerList[0].captureFromLongWidget(page1(), constraints: const BoxConstraints(
        maxHeight: 1920, minHeight: 1920, maxWidth: 1080, minWidth: 1080),).then((value) {
          imageMap[0] = value;
          setState(() {});
        });

    _screenshotControllerList[1].captureFromLongWidget(page2(), constraints: const BoxConstraints(
        maxHeight: 1920, minHeight: 1920, maxWidth: 1080, minWidth: 1080),).then((value) {
          imageMap[1] = value;
          setState(() {});
    });

    _screenshotControllerList[2].captureFromLongWidget(page3(), constraints: const BoxConstraints(
        maxHeight: 1920, minHeight: 1920, maxWidth: 1080, minWidth: 1080),).then((value) {
      imageMap[2] = value;
      setState(() {});
    });

    _screenshotControllerList[3].captureFromLongWidget(page4(), constraints: const BoxConstraints(
        maxHeight: 1920, minHeight: 1920, maxWidth: 1080, minWidth: 1080),).then((value) {
      imageMap[3] = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> pageWidgets = [mainPage1(), mainPage2(), mainPage3(), mainPage4()];

    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("감사일기 공유하기", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18),),
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
        child: Column(
            children: [
              const SizedBox(height: 20,),
              const Text("오늘의 감사일기를", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: COLOR_SUB),),
              const Text("공유해보세요!", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: COLOR_SUB),),
              const SizedBox(height: 20,),
              Expanded(
                child: PageView.builder(
                    controller: _controller,
                    itemCount: pageWidgets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(padding: const EdgeInsets.only(left: 10, right: 10),
                        child: pageWidgets[index],
                      );
                    },
                    onPageChanged: (value) {
                    setState(() {
                      _currentIndex = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 33,),
              SizedBox(
                width: 215,
                height: 43,
                child: ElevatedButton(onPressed: () async {
                  if(imageMap[0] != null) {
                    try {
                      final tempDir = await getTemporaryDirectory();
                      final filePath = '${tempDir.path}/gonggam_share${_currentIndex}_$shareDate.png';

                      await File(filePath).writeAsBytes(imageMap[_currentIndex]!);
                      final xFile = XFile(filePath);
                      Share.shareXFiles([xFile]);

                      FirebaseAnalytics.instance.logEvent(name: "share_image", parameters: {'id' : _currentIndex});

                    } catch (e) {
                      Alert.alertDialog(e.toString());
                    }
                  }
                },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(47.0),
                    ),
                    backgroundColor: COLOR_LIGHTGRAY,
                    shadowColor: Colors.transparent,
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        WidgetSpan(child: Image.asset("$IMAGE_PATH/share_icon.png", height: 21, width: 21,), alignment: PlaceholderAlignment.middle),
                        const TextSpan(text: "   "),
                        TextSpan(text: "감사일기 공유하기", style: TextStyle(fontFamily: FONT_APPLESD, fontWeight: FontWeight.bold, fontSize: 15, color: imageMap[0] != null ? Colors.black : Colors.grey, ),),
                      ]
                    ),
                  )
                ),
              ),
              const SizedBox(height: 25,)
            ]
        ),
      ),
    );
  }

  Widget mainPage1() {
    return imageMap[0] == null ? const Center(child: CircularProgressIndicator()) : Image.memory(imageMap[0]!);
  }

  Widget mainPage2() {
    return imageMap[1] == null ? const Center(child: CircularProgressIndicator()) : Image.memory(imageMap[1]!);
  }

  Widget mainPage3() {
    return imageMap[2] == null ? const Center(child: CircularProgressIndicator()) : Image.memory(imageMap[2]!);
  }

  Widget mainPage4() {
    return imageMap[3] == null ? const Center(child: CircularProgressIndicator()) : Image.memory(imageMap[3]!);
  }

  Widget  page1() {
    return Screenshot(controller: _screenshotControllerList[0],
        child: SizedBox(
          width: 1080,
          height: 1920,
          child: Stack(
            children: generateSharePage1(),),
        )
    );
  }

  List<Widget> generateSharePage1() {
    List<Widget> widgets = [];
    widgets.add(Align(
      child: Image.asset("$IMAGE_PATH/feed1.png",width: 1080, height: 1920, fit: BoxFit.fitWidth,),
    ));
    widgets.add(Align(
        alignment: Alignment.topCenter,
        child: Text(shareDate.day.toString(), style: const TextStyle(fontSize: 448, fontFamily: FONT_BODONI_BOLD, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -20),)
    ));
    widgets.add(
        Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: const EdgeInsets.only(top: 580),
                child: Text("${shareDate.year}    |    ${DateFormat('MMMM', 'en_US').format(shareDate)}    |    ${DateFormat('E', 'en_US').format(shareDate)}.", style: const TextStyle(fontSize: 51, fontFamily: FONT_BODONI_BOOK, color: Colors.white, letterSpacing: -1.5),)
            )
        )
    );

    for(int i=0; i<shareData.length; i++) {
      widgets.add(getPage1Section(i.toDouble(), shareData[i].content.replaceAll("\n", " ")));
    }
    return widgets;
  }

  Widget getPage1Section(double index, String content) {
    String num = (index + 1).toInt().toString();
    return Positioned(
        top: 720 + (index * 190),
        left: 155,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 770,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text("$num.", style: const TextStyle(fontSize: 48, fontFamily: FONT_NANUMMYNGJO, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -1.5),),
                  const SizedBox(width: 57,),
                  Container(
                    height: 165,
                    alignment: Alignment.centerLeft,
                    constraints: const BoxConstraints(
                      maxWidth: 650,
                    ),
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        text: TextSpan(
                            text: content,
                            style: const TextStyle(fontSize: 26, fontFamily: FONT_NANUMMYNGJO, color: Colors.white, height: 1.5, letterSpacing: -0.8, )
                        ),
                      ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              index == 4 ? const SizedBox.shrink() : const SizedBox(
                height: 1,
                width: 900,
                child: Divider(height: 1, thickness: 1, color: Colors.white,),
              ),
            ],
          ),
        )
    );
  }

  Widget page2() {
    return Screenshot(controller: _screenshotControllerList[1],
        child: SizedBox(
          width: 1080,
          height: 1920,
          child: Stack(
            children: generateSharePage2(),),
        )
    );
  }

  List<Widget> generateSharePage2() {
    List<Widget> widgets = [];
    widgets.add(Align(
      child: Image.asset("$IMAGE_PATH/feed2.png",width: 1080, height: 1920, fit: BoxFit.fitWidth,),
    ));
    widgets.add(Positioned(
        top: 383,
        left: 210,
        child: Text(DateFormat("yyyy.MM.dd").format(shareDate), style: const TextStyle(fontSize: 45, fontFamily: FONT_NANUMMYNGJO, color: COLOR_BOOK4, letterSpacing: -1.5),)
    ));

    for(int i=0; i<shareData.length; i++) {
      widgets.add(getPage2Section(i.toDouble(), shareData[i].content.replaceAll("\n", " ")));
    }
    return widgets;
  }

  Widget getPage2Section(double index, String content) {
    String num = (index + 1).toInt().toString();
    return Positioned(
        top: 485 + (index * 262),
        left: 210,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
          maxWidth: 650,),
          child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text("$num.", style: const TextStyle(fontSize: 50, fontFamily: FONT_NANUMMYNGJO, fontWeight: FontWeight.bold, color: COLOR_BOOK4, letterSpacing: -1.5),)),
            const SizedBox(height: 23,),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 165,
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                  text: TextSpan(
                      text: content,
                      style: const TextStyle(fontSize: 25, fontFamily: FONT_NANUMMYNGJO, color: COLOR_BOOK4, height: 1.5, letterSpacing: -1)
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35,),
          ],
        ),
        ),
    );
  }

  Widget page3() {
    return Screenshot(controller: _screenshotControllerList[2],
        child: SizedBox(
          width: 1080,
          height: 1920,
          child: Stack(
            children: generateSharePage3(),),
        )
    );
  }

  List<Widget> generateSharePage3() {
    List<Widget> widgets = [];
    widgets.add(Align(
      child: Image.asset("$IMAGE_PATH/feed3.png",width: 1080, height: 1920, fit: BoxFit.fitWidth,),
    ));
    widgets.add(Positioned(
        top: 253,
        left: 192,
        child: Text(DateFormat("yyyy.MM.dd").format(shareDate), style: const TextStyle(fontSize: 83, fontFamily: FONT_BODONI_BOOK, color: Color(0xFF932E0C), letterSpacing: -1.5),)
    ));

    for(int i=0; i<shareData.length; i++) {
      widgets.add(getPage3Section(i.toDouble(), shareData[i].content.replaceAll("\n", " ")));
    }
    return widgets;
  }

  Widget getPage3Section(double index, String content) {
    String num = (index + 1).toInt().toString();
    return Positioned(
      top: 500 + (index * 220),
      left: 195,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 770,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Text("$num.", style: const TextStyle(fontSize: 50, fontFamily: FONT_NANUMMYNGJO, fontWeight: FontWeight.bold, color: Color(0xFF932E0C), letterSpacing: -1.5),)),
                  const SizedBox(width: 38,),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    height: 140,
                    alignment: Alignment.centerLeft,
                    constraints: const BoxConstraints(
                      maxWidth: 670,
                    ),
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      text: TextSpan(
                          text: content,
                          style: const TextStyle(fontSize: 29, fontFamily: FONT_NANUMMYNGJO, color: Color(0xFF932E0C), letterSpacing: -1)
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        )
    );
  }

  Widget page4() {
    return Screenshot(controller: _screenshotControllerList[3],
        child: SizedBox(
          width: 1080,
          height: 1920,
          child: Stack(
            children: generateSharePage4(),),
        )
    );
  }

  List<Widget> generateSharePage4() {
    List<Widget> widgets = [];
    widgets.add(Align(
      child: Image.asset("$IMAGE_PATH/feed4.png",width: 1080, height: 1920, fit: BoxFit.fitWidth,),
    ));

    widgets.add(
      Container(
        alignment: AlignmentDirectional.topCenter,
        margin: const EdgeInsets.only(top: 165),
          child: Text(DateFormat("yyyy.MM.dd").format(shareDate),
                  style: const TextStyle(fontSize: 83, fontFamily: FONT_APPLESD_EXTRABOLD, color: COLOR_BOOK4, letterSpacing: -1.6),)
      )
    );

    for(int i=0; i<shareData.length; i++) {
      widgets.add(getPage4Section(i.toDouble(), shareData[i].content.replaceAll("\n", " ")));
    }
    return widgets;
  }

  Widget getPage4Section(double index, String content) {
    List<Color> colors = [COLOR_BOOK5, COLOR_BOOK4, COLOR_BOOK3, const Color(0xFF43230F), COLOR_SUB];

    String num = (index + 1).toInt().toString();
    return Positioned(
        top: 336 + (index * 272),
        left: 95,
        child: Container(
          width: 863,
          height: 232,
          padding: const EdgeInsets.only(left: 57, right: 40, top: 38, bottom: 38),
          decoration: BoxDecoration(
            color: colors[index.toInt()],
            borderRadius: const BorderRadius.all(Radius.circular(99)),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 780,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 120,
                    child: Text("0$num", style: const TextStyle(fontSize: 90, fontFamily: FONT_APPLESD_HEAVY, color: Color(0xFFF0E6DD)),)),
                const SizedBox(width: 30,),
                Container(
                  height: 160,
                  alignment: Alignment.centerLeft,
                  constraints: const BoxConstraints(
                    maxWidth: 580,
                  ),
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    text: TextSpan(
                        text: content,
                        style: const TextStyle(fontSize: 29, fontFamily: FONT_APPLESD, color: Color(0xFFF0E6DD), letterSpacing: -1)
                    ),
                  ),
                )
              ],
            )
          ),
        )
    );
  }
}
