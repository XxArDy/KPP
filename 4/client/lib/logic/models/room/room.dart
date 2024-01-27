import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class Room {
  int id;
  int number;
  int typeId;
  String? description;
  double price;

  Room({
    required this.id,
    required this.number,
    required this.typeId,
    this.description,
    required this.price,
  });

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);

  Room copyWith({
    int? id,
    int? number,
    int? typeId,
    String? description,
    double? price,
  }) {
    return Room(
      id: id ?? this.id,
      number: number ?? this.number,
      description: description ?? this.description,
      price: price ?? this.price,
      typeId: typeId ?? this.typeId,
    );
  }
}
