import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gonggam/domain/group/group.dart';
import 'package:gonggam/service/group/group_service.dart';
import 'package:get/get.dart';

import '../../common/constants.dart';
import '../../domain/member/member.dart';
import '../bookstore/invite/invite_page.dart';

Future<List<Widget>> getBottomNoteList(int groupId, String customerId, Function(String customerId) changeCustomerId) async {
  final data = await GroupService.getGroupList();
  Group group = data.groups.firstWhere((element) => element.id == groupId);
  int groupLength = group.members.length + 1;
  List<Widget> widgets = [];

  widgets.add(
      Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: buildNoteWidgets(groupId, group.members, customerId, changeCustomerId)
      )
  );

  // logo
  widgets.add(
      Positioned(
          left: 52.0 * groupLength,
          bottom: -10,
          child: Image.asset(
            "$IMAGE_PATH/book_list_logo.png",
            width: 97,
            height: 122,
          )
      )
  );
  return widgets;
}

List<Widget> buildNoteWidgets(int groupId, List<Member> members, String customerId, Function(String customerId) changeCustomerId) {
  // 멤버 버튼들
  List<Widget> widgets = members.asMap().entries.map((entry) {
    int index = entry.key;
    Member item = entry.value;
    return generateNoteWidget(item, index, customerId, changeCustomerId);
  }).toList();

  // 초대하기 버튼
  widgets.add(
      GestureDetector(
        onTap: () => {
          Get.to(const InvitePage())
        },
        child: RotatedBox(
            quarterTurns: 1,
            child: Container(
              margin: const EdgeInsets.only(top: 3.0),
              constraints: const BoxConstraints(
                  minWidth: 100,
                  maxWidth: 200
              ),
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)
                  ),
                  color: COLOR_BOOKS[4]
              ),
              padding: const EdgeInsets.all(15),
              child: const RotatedBox(quarterTurns: -1, child: Text(
                '+ 초대하기', textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),),),
            )),
      )
  );
  return widgets;
}

Widget generateNoteWidget(Member data, int index, String customerId, Function(String customerId) changeCustomerId) {
  return GestureDetector(
    onTap: () => {
      changeCustomerId(data.customerId)
    },
    child: RotatedBox(
        quarterTurns: 1,
        child: Container(
          margin: const EdgeInsets.only(top: 3.0),
          height: 50,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)
              ),
              color: COLOR_BOOKS[index]
          ),
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotatedBox(quarterTurns: -1, child: Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: data.customerId == customerId ? const AssetImage("$IMAGE_PATH/icon_check_white.png") as ImageProvider : CachedNetworkImageProvider(data.profileImage == "string" ? "https://k.kakaocdn.net/dn/dpk9l1/btqmGhA2lKL/Oz0wDuJn1YV2DIn92f6DVK/img_640x640.jpg" : data.profileImage)
                    )
                ),
              ),),
              const SizedBox(width: 10,),
              Container(
                  constraints: const BoxConstraints(maxWidth: 100,),
                  child: Text(data.nickname, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 14),))
            ],
          ),
        )),
  );
}
