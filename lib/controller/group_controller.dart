import 'package:get/get.dart';
import 'package:gonggam/common/prefs.dart';
import 'package:gonggam/domain/group/group.dart';

import '../domain/group/groups.dart';

class GroupController extends GetxController {
  Groups groups;
  Group group;
  late RxInt groupCount = 0.obs;

  GroupController(this.groups, this.group) {
    groupCount = groups.groups.length.obs;
  }

  void setGroups(Groups groups) {
    this.groups = groups;
    groupCount = groups.groups.length.obs;
  }

  void setGroup(Group group) {
    this.group = group;
  }

  void setGroupById(int groupId) {
    group = groups.groups.firstWhere((element) => element.id == groupId).copyWith();
  }

  void resetGroup() {
    group = groups.groups.first;
  }

  void setRepresentationGroup() {
    group = groups.groups.firstWhere((element) => element.isRepresentation).copyWith();
  }

  String getNickname(int groupId, String customerId) {
    return groups.groups.firstWhere((element) => element.id == groupId).members.firstWhere((element) => element.customerId == customerId).nickname;
  }
}