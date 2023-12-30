import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  String token;
  bool isNewCustomer;
  String nickname;
  String customerId;

  AuthResponse(this.token, this.isNewCustomer, this.nickname, this.customerId);

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}