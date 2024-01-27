import 'package:json_annotation/json_annotation.dart';

part 'room_type.g.dart';

@JsonSerializable()
class RoomType {
  int id;
  String? name;

  RoomType({
    required this.id,
    this.name,
  });

  factory RoomType.fromJson(Map<String, dynamic> json) =>
      _$RoomTypeFromJson(json);

  Map<String, dynamic> toJson() => _$RoomTypeToJson(this);
}
