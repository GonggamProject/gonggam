import 'dart:ffi';

import 'package:get/get.dart' as getx;
import 'package:gonggam/domain/group/group.dart';

import '../../common/http/http_client.dart';
import '../../controller/group_controller.dart';
import '../../domain/common/response.dart';
import '../../domain/group/groups.dart';
import '../../ui/common/alert.dart';

class GroupService {
  static Future<Groups> getGroupList() async {
    final response = await GongGamHttpClient().getRequest("/v1/groups", null);

    Response<Groups> res = Response.fromJson(response.data, (json) => Groups.fromJson(json as Map<String, dynamic>));

    if (getx.Get.isRegistered<GroupController>()) {
      GroupController groupController = getx.Get.find();
      groupController.setGroups(res.content!);
    }
    return res.content!;
  }

  static Future<Response<Group>> createGroup(String groupName) async {
    final response = await GongGamHttpClient().postRequest("/v1/groups", {"name": groupName});
    Response<Group> res = Response.fromJson(response.data, (json) => Group.fromJson(json as Map<String, dynamic>));
    return res;
  }
  
  static Future<String> getGroupInviteCode(int groupId) async {
    final response = await GongGamHttpClient().getRequest("/v1/groups/$groupId/join/key", null);
    Response<String> res = Response.fromJson(response.data, (json) => json as String);
    return res.content!;
  }
  
  static Future<String> joinGroup(String inviteCode) async {
    final response = await GongGamHttpClient().postRequest("/v1/groups/join", {"key": inviteCode});
    Response<Array> res = Response.fromJson(response.data, (json) => json as Array);
    return res.code;
  }

  static Future<void> changeRepresentation(int groupId) async {
    await GongGamHttpClient().putRequest("/v1/groups/representation/$groupId", null);
  }

  // 그룹 삭제
  static Future<void> removeGroup(int groupId) async {
    await GongGamHttpClient().deleteRequest("/v1/groups/$groupId", null);
  }

  // 그룹 나가기
  static Future<void> leaveGroup(int groupId) async {
    await GongGamHttpClient().deleteRequest("/v1/groups/$groupId/members", null);
  }

  // 그룹 내보내기
  static Future<void> kickOutMember(int groupId, String targetCustomerId) async {
    await GongGamHttpClient().deleteRequest("/v1/groups/$groupId/members/$targetCustomerId/kick-out", null);
    getGroupList();
  }
}