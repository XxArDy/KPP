// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
      id: json['id'] as int,
      roomId: json['roomId'] as int,
      clientId: json['clientId'] as int,
      dateStart: DateTime.parse(json['dateStart'] as String),
      dateEnd: DateTime.parse(json['dateEnd'] as String),
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
      'id': instance.id,
      'roomId': instance.roomId,
      'clientId': instance.clientId,
      'dateStart': instance.dateStart.toIso8601String(),
      'dateEnd': instance.dateEnd.toIso8601String(),
      'amount': instance.amount,
    };
