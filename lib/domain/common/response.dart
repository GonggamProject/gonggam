import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Response<T> {
  String code;
  String message;
  T? content;

  Response(this.code, this.message, this.content);

  factory Response.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    if (isPrimitiveType<T>()) {
      return Response<T>(
        json['code'] as String,
        json['message'] as String,
        fromJsonT(json['content']),
      );
    }
    return _$ResponseFromJson(json, fromJsonT);
  }

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) {
    if (isPrimitiveType<T>()) {
      return {
        'code': code,
        'message': message,
        'content': toJsonT(content as T),
      };
    }
    return _$ResponseToJson(this, toJsonT);
  }

  static bool isPrimitiveType<T>() {
    return T == String || T == int || T == double || T == bool;
  }
}