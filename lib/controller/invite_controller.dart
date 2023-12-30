import 'package:get/get.dart';

class InviteController extends GetxController {
  String inviteCode;
  String inviterName;
  String groupName;
  int groupId;

  InviteController(this.inviteCode, this.inviterName, this.groupName, this.groupId);
}