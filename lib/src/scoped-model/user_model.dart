import 'dart:convert';

CustomerModel customerModelFromJson(String str) =>
    CustomerModel.fromJson(json.decode(str));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  String name;
  String phone;
  String password;
  DateTime createdAt;

  CustomerModel({
    this.name,
    this.phone,
    this.password,
    this.createdAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
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
