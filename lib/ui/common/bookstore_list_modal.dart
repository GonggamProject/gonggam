import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gonggam/controller/group_controller.dart';

import '../../common/constants.dart';
import '../../domain/group/group.dart';
import '../createBookstore/create_bookstore_name_page.dart';

Future showBookStoreListModal(BuildContext context, GroupController groupController,
    Function(int id) changeBookStore) {
  return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children:
                getBookStoreListWidget(context, groupController, changeBookStore),
          ),
        );
      });
}

List<Widget> getBookStoreListWidget(BuildContext context, GroupController groupController,
    Function(int id) changeBookStore) {
  List<Group> bookStoreList = groupController.groups.groups;
  List<Widget> widgets = [];

  widgets.add(Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: const Text(
        "📚 책방목록",
        style:
            TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB),
      )));

  for (int i = 0; i < bookStoreList.length; i++) {
    widgets.add(const SizedBox(height: 10));
    widgets.add(
      GestureDetector(
        onTap: () {
          changeBookStore(bookStoreList[i].id);
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bookStoreList[i].name,
                        style: const TextStyle(
                          fontFamily: FONT_APPLESD,
                          fontSize: 15,
                        )),
                    bookStoreList[i].isUpdated ? getBookStoreUpdateLabel() : const SizedBox.shrink(),
                    getMainBookStoreLabel(bookStoreList[i].isRepresentation)
                  ],
                ),
              ),
              groupController.group.id == bookStoreList[i].id
                  ? Image.asset("$IMAGE_PATH/icon_check_black.png", width: 13, height: 9,)
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  widgets.add(const SizedBox(
    height: 30,
  ));

  if(groupController.groups.groups.length < 4) {
    widgets.add(
      SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            Get.off(const CreateBookStoreNameWidget());
          },
          style: ElevatedButton.styleFrom(
              side: const BorderSide(
                color: COLOR_SUB,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: Colors.white),
          child: const Text(
            "+ 책방추가하기",
            style: TextStyle(
                fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB),
          ),
        ),
      ),
    );
  }
  return widgets;
}

Widget getBookStoreUpdateLabel() {
  return Container(
    margin: const EdgeInsets.only(left: 1),
    decoration: const BoxDecoration(
      color: Colors.red,
      shape: BoxShape.circle
    ),
    height: 5,
    width: 5,
  );
}

Widget getMainBookStoreLabel(bool isRepresentation) {
  return  isRepresentation ? Container(
    margin: const EdgeInsets.only(left: 10.0),
    width: 50,
    height: 20,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: COLOR_LIGHTGRAY,
    ),
    child:const Align(
      alignment: Alignment.center,
      child: Text(
        "대표책방",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: FONT_APPLESD,
          fontSize: 8,
          color: COLOR_BOOK5,
        ),
      ),
    ),
  ) : const SizedBox.shrink();
}
