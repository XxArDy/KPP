import 'package:json_annotation/json_annotation.dart';

part 'client.g.dart';

@JsonSerializable()
class Client {
  int id;
  String? firstName;
  String? lastName;
  String? phone;

  Client({
    required this.id,
    this.firstName,
    this.lastName,
    this.phone,
  });

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  Map<String, dynamic> toJson() => _$ClientToJson(this);

  Client copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
  }) {
    return Client(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
    );
  }
}
