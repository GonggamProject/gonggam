import 'dart:convert';

import 'package:gonggam/common/http/http_client.dart';
import 'package:gonggam/common/prefs.dart';
import 'package:gonggam/domain/common/response.dart' as gonggam_response;

import '../../domain/customer/customer_info.dart';

class CustomerService {
  Future<CustomerInfo> getCustomerInfo() async {
    final response = await GongGamHttpClient()
        .getRequest("/v1/customer/me", null);

    gonggam_response.Response<CustomerInfo> res = gonggam_response.Response.fromJson(
        response.data,
            (json) => CustomerInfo.fromJson(json as Map<String, dynamic>));

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