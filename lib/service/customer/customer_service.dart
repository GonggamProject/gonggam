import 'dart:convert';

import 'package:get/get.dart';
import 'package:gonggam/common/http/http_client.dart';
import 'package:gonggam/common/prefs.dart';
import 'package:gonggam/domain/common/response.dart' as gonggam_response;
import 'package:gonggam/ui/create_nickname_page.dart';

import '../../domain/customer/customer_info.dart';
import '../../ui/common/alert.dart';
import '../auth/auth_factory.dart';

class CustomerService {
  Future<CustomerInfo> getCustomerInfo() async {
    final response = await GongGamHttpClient()
        .getRequest("/v1/customer/me", null);

    gonggam_response.Response<CustomerInfo> res = gonggam_response.Response.fromJson(
        response.data,
            (json) => CustomerInfo.fromJson(json as Map<String, dynamic>));

    if (res.code == "GG1001") {
      AuthFactory.createAuthService(Prefs.currentLoginedPlatform()).logout();
    }

    if (res.content!.nickname.isEmpty) {
      Alert.alertActionDialog("", "닉네임 입력이 필요해요!\n닉네임 입력을 진행해주세요!", () => Get.to(const CreateNicknameWidget()));
    }

    return res.content!;
  }

  Future<void> updateCustomerNickname(String newNickname) async {
    var params = {
      "newNickname": newNickname
    };

    await GongGamHttpClient().putRequest("/v1/customer/nickname", jsonEncode(params));
    Prefs.setCustomerName(newNickname);
  }

  Future<void> secession() async {
    await GongGamHttpClient().deleteRequest("/v1/customer/secession", null);
    Prefs.clear();
  }
}