import 'package:json_annotation/json_annotation.dart';

part 'customer_info.g.dart';

@JsonSerializable()
class CustomerInfo {
  String nickname;
  String profileImage;
  String state;

  CustomerInfo(this.nickname, this.profileImage, this.state);

  factory CustomerInfo.fromJson(Map<String, dynamic> json) => _$CustomerInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerInfoToJson(this);
}