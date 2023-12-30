import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../common/prefs.dart';
import '../../domain/auth/auth_request.dart';
import '../../domain/customer/customer_info.dart';
import '../../ui/createBookstore/create_bookstore_main_page.dart';
import '../../ui/create_nickname_page.dart';
import '../../ui/splash_page.dart';
import '../../utils.dart';
import '../customer/customer_service.dart';
import 'auth_interface.dart';
import 'auth_service.dart';

class AppleAuthService implements AuthInterface {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Future<void> login() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    AuthRequest user = AuthRequest(
        credential.toString(),
        "APPLE",
        "",
        Utils.getProfileImageUrl(credential.hashCode)
    );
    loginSuccess(user);
  }


  @override
  Future<void> loginSuccess(AuthRequest authRequest) async {
    bool isNewUser = await AuthService().authenticate(authRequest);
    Prefs.setString("currentLoginedPlatform", "apple");
    Prefs.setBool("isLogin", true);
    if(isNewUser) { // 신규유저 -> 닉네임 입력
      Get.off(const CreateNicknameWidget(), arguments: authRequest.nickname);
    } else {
      CustomerInfo info = await CustomerService().getCustomerInfo();
      if(info.nickname.isEmpty) { // 닉네임이 없는 유저 로그인 -> 닉네임 입력
        Get.off(const CreateNicknameWidget(), arguments: authRequest.nickname);
      } else {
        Get.off(const CreateBookStoreMainWidget());
      }
    }
  }

  @override
  Future<void> logout() async {
    Prefs.clear();
    await storage.deleteAll();
    Get.offAll(const SplashWidget());
  }

  @override
  Future<void> loginFail() {
    // TODO: implement loginFail
    throw UnimplementedError();
  }

}