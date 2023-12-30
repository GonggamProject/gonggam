import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gonggam/common/http/http_client.dart';
import 'package:gonggam/common/prefs.dart';
import 'package:gonggam/domain/common/response.dart';
import 'package:gonggam/domain/auth/auth_request.dart';

import '../../domain/auth/auth_response.dart';

class AuthService {

  FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> authenticate(AuthRequest authRequest) async {
    final response = await GongGamHttpClient()
        .postRequest("/v1/authenticate", authRequest.toJson());
    Response<AuthResponse> res = Response.fromJson(
            response.data,
            (json) => AuthResponse.fromJson(json as Map<String, dynamic>));
    await storage.write(key: "token", value: res.content!.token);
    Prefs.setCustomerName(res.content!.nickname);
    Prefs.setString("customerId", res.content!.customerId);
    return res.content!.isNewCustomer;
  }
}