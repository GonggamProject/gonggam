import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

import '../../common/constants.dart';

class ShareNoteWidget extends StatefulWidget {
  const ShareNoteWidget({super.key});

  @override
  State<ShareNoteWidget> createState() => _ShareNoteWidgetState();
}

class _ShareNoteWidgetState extends State<ShareNoteWidget>{
  final _now = DateTime.now();
  final _controller = PageController(initialPage: 0, viewportFraction:0.8);
  final _screenshotController = ScreenshotController();
  int _currentIndex = 0;
  Uint8List image1 = Uint8List.fromList([]);

  @override
  void initState() {
    setNewImage();
  }

  void setNewImage() {
    _screenshotController.captureFromLongWidget(page3(), constraints: const BoxConstraints(
        maxHeight: 1920, minHeight: 1920, maxWidth: 1080, minWidth: 1080),).then((value) {
      image1 = value;
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> pageWidgets = [page1(), page1()];
    int lastIndex = pageWidgets.length - 1;

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
                      return Padding(padding: EdgeInsets.only(left: 10, right: 10),
                        child: pageWidgets[index],
                      );
                    },
                    // physics: const ClampingScrollPhysics(),
                    // scrollDirection: Axis.horizontal,
                    // controller: _controller,
                    // onPageChanged: (value) {
                    //   setState(() {
                    //     _currentIndex = value;
                    //   });
                    // },
                    // children: pageWidgets
                ),
              ),
              const SizedBox(height: 33,),
              SizedBox(
                width: 215,
                height: 43,
                child: ElevatedButton(onPressed: () {
                  // _currentIndex == lastIndex ?
                  //     Get.off(const LoginWidget())
                  //     : _controller.animateToPage(++_currentIndex, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                  _screenshotController.capture().then((value) async {

                    image1 = value!;
                    print(image1);
                    setState(() {

                    });
                    // var res = await ImageGallerySaver.saveImage(value!, quality: 60, name: "test.png");
                    // MemoryImage(res);
                    // var path = await LecleFlutterAbsolutePath.getAbsolutePath(uri: res["filePath"]);
                    // print(path);
                    // Share.shareXFiles([XFile(path!)], subject: '100일 챌린지');

                    // InstagramSharePlus.shareInstagram(path: path, type: "image");
                    // SocialShare.shareInstagramStory(appId: "281461371314772", imagePath: path!);

                    String instagramUsername = "gonggambook";
                    String imageUrl = "https://fastly.picsum.photos/id/250/200/300.jpg"; // 이미지의 URL 또는 파일 경로
                    // String url = "instagram://stories"

                    // if (await canLaunch(url)) {
                    //   await launch(url);
                    // } else {
                    //   print("Could not launch Instagram.");
                    // }
                  });
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
                        WidgetSpan(child: Image.asset("$IMAGE_PATH/download_icon.png", height: 21, width: 21,), alignment: PlaceholderAlignment.middle),
                        const TextSpan(text: "   "),
                        const TextSpan(text: "감사일기 공유하기", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: Colors.black, ),),
                      ]
                    ),
                  )
                ),
              ),
            ]
        ),
      ),
    );
  }

  Widget page1() {
    return image1.isEmpty ? const Center(child: CircularProgressIndicator()) : Image.memory(image1);
  }

  Widget page3() {
    return Screenshot(controller: _screenshotController,
        child: Container(
          color: Colors.red,
          width: 1080,
          height: 1920,
          child: Stack(
            children: [
              Align(
                child: Image.asset("$IMAGE_PATH/feed1.png",width: 1080, height: 1920, fit: BoxFit.fitWidth,),
              ),
              const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text("30", style: TextStyle(fontSize: 500, fontFamily: FONT_BODONI_BOLD, fontWeight: FontWeight.bold, color: Colors.red, letterSpacing: -20),),
                )
              ),
              Positioned(
                  top: 666,
                  left: 252,
                  child: Text("2024", style: TextStyle(fontSize: 53, fontFamily: FONT_BODONI_BOOK, color: Colors.red, letterSpacing: -1.5),)
              ),
              Positioned(
                  top: 666,
                  left: 470,
                  child: Text("January", style: TextStyle(fontSize: 53, fontFamily: FONT_BODONI_BOOK, color: Colors.red, letterSpacing: -1.5),)
              ),
              Positioned(
                  top: 666,
                  left: 756,
                  child: Text("Fri.", style: TextStyle(fontSize: 53, fontFamily: FONT_BODONI_BOOK, color: Colors.red, letterSpacing: -1.5),)
              ),
              getPage1Section()
          ],),
        )
    );
  }

  Widget getPage1Section() {
    return  Positioned(
        top: 666,
        left: 756,
        child: Row(
          children: [
            Text("1.", style: TextStyle(fontSize: 53, fontFamily: FONT_BODONI_BOOK, color: Colors.red, letterSpacing: -1.5),),
            Text("동해물과백두산이마르고닳도록하나님이보우하사우리나라만세무궁화삼천리화려강산대한사람대한으", style: TextStyle(fontSize: 53, fontFamily: FONT_BODONI_BOOK, color: Colors.red, letterSpacing: -1.5),)
          ],
        )
    );
  }
}
