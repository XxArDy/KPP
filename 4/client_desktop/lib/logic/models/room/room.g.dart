// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      id: json['id'] as int,
      number: json['number'] as int,
      typeId: json['typeId'] as int,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String?,
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'typeId': instance.typeId,
      'description': instance.description,
      'price': instance.price,
      'image': instance.image,
    };
