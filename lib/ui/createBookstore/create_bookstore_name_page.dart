import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gonggam/ui/createBookstore/create_bookstore_complete_page.dart';
import '../../common/constants.dart';
import '../../controller/group_controller.dart';
import '../../domain/common/response.dart' as gonggam_response;
import '../../domain/group/group.dart';
import '../../domain/group/groups.dart';
import '../../service/group/group_service.dart';
import '../common/alert.dart';

class CreateBookStoreNameWidget extends StatefulWidget {
  const CreateBookStoreNameWidget({super.key});

  @override
  State<CreateBookStoreNameWidget> createState() => _CreateBookStoreNameWidgetState();
}

class _CreateBookStoreNameWidgetState extends State<CreateBookStoreNameWidget> {
  final String groupnameLengthGuide = "책방이름은 최대 10자까지 작성할 수 있어요.";
  final String groupnameExistGuide = "이미 사용중인 이름이에요.";

  String groupName = "";
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("책방 만들기", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18),),
        foregroundColor: Colors.black,
        backgroundColor: COLOR_BACKGROUND,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), onPressed: () {
            Get.back();
        },
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            minimum: PADDING_MINIMUM_SAFEAREA,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 65,),
                    Image.asset("$IMAGE_PATH/create_bookstore_nickname_image.png", width: 185, height: 177,),
                    const SizedBox(height: 20,),
                    const Text("감사일기를 공유할", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: COLOR_SUB),),
                    const SizedBox(height: 5,),
                    const Text("책방이름을 적어주세요", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: COLOR_SUB),),
                    const SizedBox(height: 30,),
                    TextField(
                      maxLength: MAX_GROUPNAME_LENGTH,
                      controller: controller,
                      decoration: InputDecoration(
                        suffix: RichText(text: TextSpan(
                            children: [
                              TextSpan(
                                  text: groupName.length.toString(),
                                  style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 12, color: COLOR_BOOK4, fontWeight: FontWeight.bold)
                              ),
                              const TextSpan(
                                  text: " / ",
                                  style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 12, color: COLOR_SUB, fontWeight: FontWeight.bold)
                              ),
                              TextSpan(
                                  text: MAX_GROUPNAME_LENGTH.toString(),
                                  style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 12, color: COLOR_SUB, fontWeight: FontWeight.bold)
                              ),
                            ]
                        ),),
                        contentPadding: const EdgeInsets.all(20),
                        counterText: "",
                        hintText: "책방이름",
                        hintStyle: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 15, color: Color(0xFFB4B4B4),),
                        filled: true,
                        fillColor: const Color(0xFFF2F2F2),
                        border: InputBorder.none,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFF2F2F2),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder:  const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFF2F2F2),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        errorBorder:  const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFF2F2F2),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),

                        ),
                        focusedErrorBorder:  const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFF2F2F2),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣]")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          groupName = value;
                        });
                      },
                      cursorRadius: const Radius.circular(5),
                    ),
                    const SizedBox(height: 5),
                    groupName.isEmpty ? const Text("") : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5,),
                        Text(groupnameLengthGuide, style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 12, color: COLOR_BOOK4),)
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(onPressed: () {
                        groupName.isNotEmpty ? moveBookStoreCompletePage(groupName) : null;
                      },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: groupName.isNotEmpty ? COLOR_BOOK5 : const Color(0xFFCDCDCD),
                            shadowColor: Colors.transparent,
                         ),
                        child: const Text("책방 만들기", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18),),
                      ),),
                    const SizedBox(height: 15),
                  ],
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("∙ 책방은 최대 4명까지 공유할 수 있어요.", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 12, color: COLOR_GRAY),),
                    SizedBox(height: 5),
                    Text("∙ 공유 받은 사람만 감사 일기를 볼 수 있어요.", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 12, color: COLOR_GRAY),),
                    SizedBox(height: 5),
                    Text("∙ 책방은 최대 4개까지 만들수 있어요.", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 12, color: COLOR_GRAY),),
                ],
                )
              ],
            )
            ),
      ),
    );
  }

  void moveBookStoreCompletePage(String groupName) async {
    gonggam_response.Response<Group> res = await GroupService.createGroup(groupName);
    if(res.code != "GG200") {
      Alert.alertDialog(res.message);
      return;
    }

    Groups groups = await GroupService.getGroupList();
    Group group = groups.groups.firstWhere((element) => element.name == groupName).copyWith();

    if(Get.isRegistered<GroupController>()) {
      GroupController groupController = Get.find();
      groupController.groups = groups;
      groupController.setGroup(group);
    } else {
      Get.put(GroupController(groups, group), permanent: true);
    }
    Get.off(const CreateBookStoreCompleteWidget());
  }
}
