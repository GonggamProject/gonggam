import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/constants.dart';
import 'login_page.dart';


class WalkthroughtWidget extends StatefulWidget {
  const WalkthroughtWidget({super.key});

  @override
  State<WalkthroughtWidget> createState() => _WalkthroughtWidgetState();
}

class _WalkthroughtWidgetState extends State<WalkthroughtWidget>{
  final _controller = PageController();

  int _currentIndex = 0;

  createCircle({required int index}) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.only(right: 8),
        height: 8,
        width: 8,
        decoration: BoxDecoration(
            color: _currentIndex == index ? WALKTHROUGH_COLOR_DOT_ACTIVE : WALKTHROUGH_COLOR_DOT , borderRadius: BorderRadius.circular(3)));
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> pageWidgets = [page1(), page2(), page3(), page4(), page5(), page6()];
    int lastIndex = pageWidgets.length - 1;

    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      body: SafeArea(
        minimum: PADDING_MINIMUM_SAFEAREA,
        child: Column(
            children: [
              Expanded(
                child: PageView(
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    onPageChanged: (value) {
                      setState(() {
                        _currentIndex = value;
                      });
                    },
                    children: pageWidgets
                ),
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 23),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(pageWidgets.length,
                            (index) => createCircle(index: index)),
                  )
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(onPressed: () {
                  _currentIndex == lastIndex ?
                      Get.off(const LoginWidget())
                      : _controller.animateToPage(++_currentIndex, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: COLOR_BOOK5,
                      shadowColor: Colors.transparent,
                  ),
                  child: Text(_currentIndex == lastIndex ? "확인" : "다음", style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: Colors.white),),
                ),
              ),
            ]
        ),
      ),
    );
  }

  Widget page1() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("$IMAGE_PATH/walkthrough_image1.png", width: 262.05, height: 202,),
        const SizedBox(height: 65.0),
        const Text("공감책방에 오신걸 환영해요!", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB),),
        const SizedBox(height: 5.0),
        RichText(
            text: const TextSpan(
                text: "저는 책방을 운영하는 ", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB),
                children: <TextSpan>[
                  TextSpan(text: "“공감”", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB, fontWeight: FontWeight.bold)),
                  TextSpan(text: "이에요.", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB)),
                ]
            )
        ),
        const SizedBox(height: 30.0),
        RichText(
            text: const TextSpan(
                text: "이곳은 ", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB),
                children: <TextSpan>[
                  TextSpan(text: "공", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_BOOK3, fontWeight: FontWeight.bold, decoration: TextDecoration.underline,)),
                  TextSpan(text: "유하는 ", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_BOOK3, decoration: TextDecoration.underline,)),
                  TextSpan(text: "감", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_BOOK3, fontWeight: FontWeight.bold, decoration: TextDecoration.underline,)),
                  TextSpan(text: "사일기를", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_BOOK3, decoration: TextDecoration.underline,)),
                ]
            )
        ),
        const SizedBox(height: 5.0),
        RichText(
            text: const TextSpan(
                text: "모아놓은 책방", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_BOOK3, decoration: TextDecoration.underline,),
                children: <TextSpan>[
                  TextSpan(text: "이에요.", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB,)),
                ]
            )
        ),
        const SizedBox(height: 5.0),
        const Text("공감책방을 통해 친구들과", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB),),
        const SizedBox(height: 5.0),
        const Text("감사일기를 공유해보세요!", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB),),
      ],
    );
  }

  Widget page2() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Image.asset("$IMAGE_PATH/walkthrough_image2.png", width: 354, height: 607,)),
          const SizedBox(height: 25.0),
          const Text("가운데 버튼을 눌러", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB),),
          const SizedBox(height: 5.0),
          const Text("오늘의 감사일기를 작성할 수 있어요.", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB),),
        ]
    );
  }

  Widget page3() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Image.asset("$IMAGE_PATH/walkthrough_image3.png", width: 354, height: 607,)),
          const SizedBox(height: 25.0),
          const Text("초대 하기 버튼을 눌러", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB),),
          const SizedBox(height: 3.0),
          const Text("친구를 초대할 수 있어요.", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB),),
        ]
    );
  }

  Widget page4() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Image.asset("$IMAGE_PATH/walkthrough_image4.png", width: 354, height: 607,)),
          const SizedBox(height: 25.0),
          const Text("친구의 책을 누르면", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB),),
          const SizedBox(height: 5.0),
          const Text("친구들의 감사일기를 확인할 수 있어요.", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB),),
        ]
    );
  }

  Widget page5() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Image.asset("$IMAGE_PATH/walkthrough_image5.png", width: 354, height: 607,)),
          const SizedBox(height: 25.0),
          const Text("책방이름을 눌러", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB),),
          const SizedBox(height: 5.0),
          const Text("다른 책방으로 이동할 수 있어요.", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB),),
        ]
    );
  }

  Widget page6() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Image.asset("$IMAGE_PATH/walkthrough_image6.png", width: 354, height: 607,)),
          const SizedBox(height: 25.0),
          const Text("이제 친구들과", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB),),
          const SizedBox(height: 5.0),
          const Text("감사일기를 공유해보세요!", style: TextStyle(fontSize: WALKTHROUGH_FONT_SIZE, fontFamily: FONT_APPLESD, color: COLOR_SUB),),
        ]
    );
  }

}
