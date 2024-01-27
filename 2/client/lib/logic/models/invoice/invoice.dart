import 'package:json_annotation/json_annotation.dart';

part 'invoice.g.dart';

@JsonSerializable()
class Invoice {
  int id;
  int roomId;
  int clientId;
  DateTime dateStart;
  DateTime dateEnd;
  double amount;

  Invoice({
    required this.id,
    required this.roomId,
    required this.clientId,
    required this.dateStart,
    required this.dateEnd,
    required this.amount,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);

  Invoice copyWith({
    int? id,
    int? roomId,
    int? clientId,
    DateTime? dateStart,
    DateTime? dateEnd,
    double? amount,
  }) {
    return Invoice(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      clientId: clientId ?? this.clientId,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      amount: amount ?? this.amount,
    );
  }
}
