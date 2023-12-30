
import 'package:json_annotation/json_annotation.dart';

part 'auth_request.g.dart';

@JsonSerializable()
class AuthRequest {
  String uid;
  String platformType;
  String? nickname;
  String? profileImageUrl;

  AuthRequest(this.uid, this.platformType, this.nickname, this.profileImageUrl);

  factory AuthRequest.fromJson(Map<String, dynamic> json) => _$AuthRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AuthRequestToJson(this);
}