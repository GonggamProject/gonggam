import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gonggam/domain/group/group.dart';
import 'package:gonggam/domain/note/note.dart';
import 'package:gonggam/service/note/note_service.dart';
import 'package:gonggam/ui/bookstore/bookstore_main.dart';
import 'package:gonggam/utils.dart';
import '../../common/admob/admob.dart';
import '../../common/constants.dart';
import '../../controller/group_controller.dart';
import '../../domain/note/notes.dart';
import '../../domain/common/response.dart' as gonggam_response;
import '../common/bookstore_list_modal.dart';

class CreateNoteWidget extends StatefulWidget {
  const  CreateNoteWidget({super.key});

  @override
  State<CreateNoteWidget> createState() => _CreateNoteWidgetState();
}

class _CreateNoteWidgetState extends State<CreateNoteWidget> {
  final GroupController groupController = Get.find<GroupController>();
  final int currentDateState = Get.arguments ?? 0;
  late int groupId = groupController.group.id;
  late bool isEditMode = false;
  final ScrollController _scrollController = ScrollController();
  final List<String> hintOrderText = ["첫", "두", "세", "네", "다섯"];

  final noteDataList = LinkedList<NoteData>();
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    getNoteData();
  }

  void getNoteData() async {
    gonggam_response.Response<Notes> noteRes = await NoteService.getNoteList(null, groupId, Utils.formatDate("yyyyMMdd", currentDateState));
    List<Note> noteList = noteRes.content!.list;
    if (noteList.isEmpty) {
      _focusNodes.add(FocusNode());
      noteDataList.add(NoteData());
    } else {
      isEditMode = true;
      for (var note in noteList) {
        _focusNodes.add(FocusNode());
        noteDataList.add(NoteData.edit(note));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "감사일기 작성",
          style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 15),
        ),
        foregroundColor: Colors.black,
        backgroundColor: COLOR_BACKGROUND,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
          minimum: PADDING_MINIMUM_SAFEAREA,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20,),
              GestureDetector(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.7,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.black),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(groupController.group.name),
                        const Icon(Icons.keyboard_arrow_down)
                      ],),
                  ),
                ),
                onTap: () {
                  showBookStoreListModal(context, groupController, (id) {
                    Group group = groupController.groups.groups.firstWhere((element) => element.id == id);
                    groupController.setGroup(group.copyWith());
                    setState(() {});
                  });
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: _scrollController,
                  child: Stack(
                    children: [
                      Positioned(
                          top: -15,
                          right: 0,
                          child:
                          Image.asset("$IMAGE_PATH/create_note_logo.png", width: 127, height: 100,)),
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          children: getNoteWidgets()),
                      const Positioned(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "오늘 하루 감사했던 일을",
                                style: TextStyle(
                                    fontFamily: FONT_APPLESD,
                                    fontSize: 15,
                                    color: COLOR_SUB),
                              ),
                              Text("작성해주세요.",
                                  style: TextStyle(
                                      fontFamily: FONT_APPLESD,
                                      fontSize: 15,
                                      color: COLOR_SUB)),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom > 0 ? 62 : 92,
              ),
            ],
          ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8, // 조절 가능한 높이
        ),
        child: Container(
          margin: const EdgeInsets.only(left: 30, right: 30, bottom: 32),//bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 32),
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              if (isAllNoteWrited()) {
                NoteService.postNoteList(groupController.group.id, Utils.formatDate("yyyyMMdd", currentDateState), noteDataList, isEditMode).then((value) {
                  showAd();
                  Get.off(const BookStoreMainWidget(), arguments: {"isRefresh": true, "currentDateState": currentDateState});
                });
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: isAllNoteWrited() ? COLOR_BOOK5 : const Color(0xFFCDCDCD))),
              backgroundColor: isAllNoteWrited() ? COLOR_BOOK5 : const Color(0xFFCDCDCD),
              shadowColor: Colors.transparent,
            ),
            child: const Text(
              "작성완료",
              style: TextStyle(
                  fontFamily: FONT_APPLESD,
                  fontSize: 18,
                  color: Colors.white),
            ),
          ),
        ),
      )
    );
  }

  List<Widget> getNoteWidgets() {
    List<Widget> widgets = [];

    for(int i = 0; i < noteDataList.length; i++) {
      widgets.add(getNoteWidget(i, noteDataList.elementAt(i)));
    }

    if (noteDataList.length < MAX_NOTE_COUNT) {
      widgets.add(addNoteTextFieldButton());
    }

    widgets.add(Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("최대 5개까지 작성할 수 있어요."),
        RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: noteDataList.length.toString(),
                  style: TextStyle(
                      fontFamily: FONT_APPLESD,
                      fontSize: 12,
                      color: noteDataList.length == MAX_NOTE_COUNT ? COLOR_BOOK4 : COLOR_BOOK5,
                      fontWeight: FontWeight.bold)),
              const TextSpan(
                  text: " / ",
                  style: TextStyle(
                      fontFamily: FONT_APPLESD,
                      fontSize: 12,
                      color: COLOR_SUB)),
              TextSpan(
                  text: MAX_NOTE_COUNT.toString(),
                  style: const TextStyle(
                      fontFamily: FONT_APPLESD,
                      fontSize: 12,
                      color: COLOR_SUB)),
            ]))
      ],
    ));

    if (noteDataList.length == MAX_NOTE_COUNT) {
      widgets.add(const SizedBox(height: 35));
    }

    return widgets;
  }

  Widget getNoteWidget(int index, NoteData data) {
    return Stack(
      children: [
        Padding(
          padding: index == 0 ? const EdgeInsets.only(top: 60.0, bottom: 12) : const EdgeInsets.only(bottom: 12),
          child: SizedBox(
            height: 99,
            child: TextField(
              focusNode: _focusNodes[index],
              controller: data.controller,
              keyboardType: TextInputType.text,
              maxLength: 45,
              maxLines: 2,
              decoration: InputDecoration(
                  counterText: "",
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 65, 40),
                  fillColor: const Color(0xFFF2F2F2),
                  hintText: "${hintOrderText[index]}번째 감사한 일을 작성해주세요.",
                  hintStyle: const TextStyle(
                      fontFamily: FONT_APPLESD,
                      fontSize: 15,
                      color: COLOR_GRAY),
                  filled: true,
                  enabledBorder: const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        width: 3, color: Color(0xFFF2F2F2)),
                  ),
                  disabledBorder: const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        width: 3, color: Color(0xFFF2F2F2)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                        width: 3, color: Color(0xFFF2F2F2)),
                  )), onChanged: (value) {
                setState(() {
                  noteDataList.elementAt(index).dataLength = value.length;
                });
              },
            ),
          ),
        ),
        index == 0 ? const SizedBox.shrink() : Positioned(
          top: 5,
          right: 10,
          child: SizedBox(
            height: 55,
            width: 50,
            child: TextButton(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.resolveWith((states) =>
                const TextStyle(
                    fontFamily: FONT_APPLESD,
                    fontSize: 12,
                    color: COLOR_GRAY)),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                padding: MaterialStateProperty.resolveWith(
                        (states) => const EdgeInsets.fromLTRB(18, 10, 10, 30)),
              ),
              onPressed: () {
                setState(() {
                    noteDataList.elementAt(index).unlink();
                    _focusNodes.removeAt(index);
                });
              },
              child: const Text(
                "삭제", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 12, color: COLOR_GRAY,)
              ),
            ),
          ),
        ),
        Positioned(
            top: 130,
            right: 20,
            child: Text(
              "${noteDataList.elementAt(index).dataLength}자 / 최대 45자",
              style: const TextStyle(
                  fontFamily: FONT_APPLESD, fontSize: 12, color: COLOR_GRAY),
            )),
      ],
    );
  }

  Widget addNoteTextFieldButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _focusNodes.add(FocusNode());
                noteDataList.add(NoteData());
              });

              Future.delayed(const Duration(milliseconds: 10), () {
                FocusScope.of(context).requestFocus(_focusNodes.last);
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent + MediaQuery.of(context).viewInsets.bottom + 50,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear,);
              });
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: COLOR_SUB)),
                backgroundColor: Colors.white,
              shadowColor: Colors.transparent,
            ),
            child: const Text(
              "감사일기 추가",
              style: TextStyle(
                  fontFamily: FONT_APPLESD, fontSize: 15, color: COLOR_SUB),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  bool isAllNoteWrited() {
    return noteDataList.where((note) => note.getNoteTextLength() == 0).toList().isEmpty;
  }

  double _calculateNewHeight(String text) {
    int numberOfLines = '\n'.allMatches(text).length + 1;
    double newHeight = numberOfLines * 20.0; // Adjust the factor as needed
    return newHeight < 99 ? 99 : newHeight;
  }
}

class NoteData extends LinkedListEntry<NoteData> {
  final controller = TextEditingController();
  int dataLength = 0;

  NoteData();

  NoteData.edit(Note note) {
    controller.text = note.content;
    noteId = note.noteId!;
  }

  String getNoteText() => controller.text;
  int getNoteTextLength() {return dataLength;}
  late int? noteId = null;
  late double textFieldHight = 99.0;
}

