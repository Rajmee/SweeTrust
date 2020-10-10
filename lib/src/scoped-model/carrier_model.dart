import 'dart:convert';

CarrierModel CarrierModelFromJson(String str) =>
    CarrierModel.fromJson(json.decode(str));

String CarrierModelToJson(CarrierModel data) => json.encode(data.toJson());

class CarrierModel {
  String name;
  String phone;
  String password;
  DateTime createdAt;

  CarrierModel({
    this.name,
    this.phone,
    this.password,
    this.createdAt,
  });

  factory CarrierModel.fromJson(Map<String, dynamic> json) => CarrierModel(
        name: json["name"],
        phone: json["phone"],
        password: json["password"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "password": password,
        "createdAt": createdAt.toIso8601String(),
      };
}
