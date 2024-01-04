import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:gonggam/common/prefs.dart';
import 'package:gonggam/controller/group_controller.dart';
import 'package:gonggam/domain/customer/customer_info.dart';
import 'package:gonggam/domain/group/group.dart';
import 'package:gonggam/service/customer/customer_service.dart';
import 'package:gonggam/service/group/group_service.dart';
import 'package:gonggam/ui/bookstore/bookstore_main.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as Kakao;
import '../../domain/auth/auth_request.dart' as gonggam_auth;
import '../../domain/group/groups.dart';
import '../../ui/createBookstore/create_bookstore_main_page.dart';
import '../../ui/create_nickname_page.dart';
import '../../ui/splash_page.dart';
import '../../utils.dart';
import 'auth_interface.dart';
import 'auth_service.dart';

class KakaoAuthService implements AuthInterface {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Future<void> login() async {
    if (await Kakao.isKakaoTalkInstalled()) {
      print("kakaotalk installed");

      await Kakao.UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } else {
        print("kakaotalk not installed");
        await Kakao.UserApi.instance.loginWithKakaoAccount();
      }

      Kakao.User user = await Kakao.UserApi.instance.me();
      gonggam_auth.AuthRequest authRequest = gonggam_auth.AuthRequest(
        user.id.toString(),
        "KAKAO",
        user.kakaoAccount?.profile?.nickname?.replaceAll(RegExp("[^0-9a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣]"), ""),
        Utils.getProfileImageUrl(user.id.toString().hashCode)
      );

      loginSuccess(authRequest);
  }

  @override
  Future<void> loginSuccess(gonggam_auth.AuthRequest authRequest) async {
    bool isNewUser = await AuthService().authenticate(authRequest);
    Prefs.setString("currentLoginedPlatform", "kakao");
    Prefs.setBool("isLogin", true);

    if(isNewUser) { // 신규유저 -> 닉네임 입력
      Get.off(const CreateNicknameWidget(), arguments: authRequest.nickname?.replaceAll(RegExp("[^0-9a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣]"), ""));
    } else {
      CustomerInfo info = await CustomerService().getCustomerInfo();
      Groups groups = await GroupService.getGroupList();

      if(info.nickname.isEmpty) { // 닉네임이 없는 유저 로그인 -> 닉네임 입력
        Get.off(const CreateNicknameWidget(), arguments: authRequest.nickname?.replaceAll(RegExp("[^0-9a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣]"), ""));
      } else {
        if(!Get.isRegistered<GroupController>()) {
          Group? group = groups.groups.firstWhereOrNull((element) => element.isRepresentation);
          group ??= groups.groups.first;
          Get.put(GroupController(groups, group!.copyWith()), permanent: true);
        }
        Get.off(groups.groups.isEmpty ? const CreateBookStoreMainWidget() : const BookStoreMainWidget());
      }
    }
  }

  @override
  Future<void> logout() async {
    Kakao.UserApi.instance.logout();
    await storage.deleteAll();
    Prefs.clear();
    Get.offAll(const SplashWidget());
  }

  @override
  Future<void> loginFail() {
    // TODO: implement loginFail
    throw UnimplementedError();
  }
}
