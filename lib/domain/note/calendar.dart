import 'package:json_annotation/json_annotation.dart';

part 'calendar.g.dart';

@JsonSerializable()
class Calendar {
  List<String> writtenDates = [];

  Calendar(this.writtenDates);

  factory Calendar.fromJson(Map<String, dynamic> json) => _$CalendarFromJson(json);
  Map<String, dynamic> toJson() => _$CalendarToJson(this);
}