import '../../domain/auth/auth_request.dart';

abstract class AuthInterface {
  Future<void> login();
  Future<void> logout();
  Future<void> loginSuccess(AuthRequest authRequest);
  Future<void> loginFail();
}