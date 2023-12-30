import 'package:json_annotation/json_annotation.dart';

part 'string_response.g.dart';

@JsonSerializable()
class StringResponse {
  String code;
  String message;
  String content;

  StringResponse(this.code, this.message, this.content);

  factory StringResponse.fromJson(Map<String, dynamic> json) => _$StringResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StringResponseToJson(this);
}