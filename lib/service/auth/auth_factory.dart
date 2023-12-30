import 'package:gonggam/service/auth/auth_interface.dart';
import 'package:gonggam/service/auth/kakao_auth_service.dart';

import 'apple_auth_service.dart';

class AuthFactory {
  static AuthInterface createAuthService(String platform) {
      switch(platform) {
        case 'kakao':
          return KakaoAuthService();
        case 'apple':
          return AppleAuthService();
        default:
          throw Exception("지원하지 않는 플랫폼입니다.");
      }
  }
}