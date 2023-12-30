import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gonggam/ui/common/bottom_navigation_bar.dart';
import '../../common/constants.dart';
import '../../controller/group_controller.dart';
import './create_bookstore_name_page.dart';

class CreateBookStoreMainWidget extends StatefulWidget {
  const CreateBookStoreMainWidget({super.key});

  @override
  State<CreateBookStoreMainWidget> createState() => _CreateBookStoreMainWidgetState();
}

class _CreateBookStoreMainWidgetState extends State<CreateBookStoreMainWidget> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: COLOR_BACKGROUND,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("공감책방", style: TextStyle(fontFamily: FONT_NANUMMYNGJO, fontSize: 15),),
          foregroundColor: Colors.black,
          backgroundColor: COLOR_BACKGROUND,
          elevation: 0,
        ),
        body: SafeArea(
            minimum: PADDING_MINIMUM_SAFEAREA,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Column(children: [
                  const SizedBox(height: 16,),
                  Image.asset("$IMAGE_PATH/create_bookstore_main.png", width: 243, height: 131,)
                ],)),
                SizedBox(
                  height: 185,
                  child: Stack(alignment: Alignment.bottomRight, children: [
                    Positioned(
                      bottom: 58,
                      child: Image.asset("$IMAGE_PATH/create_bookstore_button_logo.png", width: 352, height: 137,),),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(onPressed: () {
                        Get.to(const CreateBookStoreNameWidget());
                      },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: COLOR_BOOK5,
                            shadowColor: Colors.transparent,
                        ),
                        child: const Text("공감책방 만들기", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18),),
                      ),
                    ),
                  ],
                  ),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 40))
            ],
            )
        ),
        bottomNavigationBar: getBottomNavigationBar(context, Get.isRegistered<GroupController>() ? Get.find<GroupController>() : null)
    );
  }
}
