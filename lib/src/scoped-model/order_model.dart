import 'dart:convert';

List<OrderModel> orderModelFromJson(String str) =>
    List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

String orderModelToJson(List<OrderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel {
  OrderModel({
    this.quantity,
    this.g,
    this.carrierPhn,
    this.phn,
    this.expectedTime,
    this.location,
    this.orderStatus,
    this.coordinates,
    this.deliveryCharge,
    this.orderId,
    this.price,
    this.notes,
  });

  String quantity;
  G g;
  String carrierPhn;
  String phn;
  String expectedTime;
  Coordinates location;
  String orderStatus;
  Coordinates coordinates;
  String deliveryCharge;
  int orderId;
  String price;
  String notes;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        quantity: json["quantity"] == null ? null : json["quantity"],
        g: json["g"] == null ? null : G.fromJson(json["g"]),
        carrierPhn: json["carrierPhn"],
        phn: json["phn"] == null ? null : json["phn"],
        expectedTime:
            json["expectedTime"] == null ? null : json["expectedTime"],
        location: json["location"] == null
            ? null
            : Coordinates.fromJson(json["location"]),
        orderStatus: json["orderStatus"] == null ? null : json["orderStatus"],
        coordinates: Coordinates.fromJson(json["coordinates"]),
        deliveryCharge: json["deliveryCharge"],
        orderId: json["orderId"],
        price: json["price"] == null ? null : json["price"],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity == null ? null : quantity,
        "g": g == null ? null : g.toJson(),
        "carrierPhn": carrierPhn,
        "phn": phn == null ? null : phn,
        "expectedTime": expectedTime == null ? null : expectedTime,
        "location": location == null ? null : location.toJson(),
        "orderStatus": orderStatus == null ? null : orderStatus,
        "coordinates": coordinates.toJson(),
        "deliveryCharge": deliveryCharge,
        "orderId": orderId,
        "price": price == null ? null : price,
        "notes": notes,
      };
}

class Coordinates {
  Coordinates({
    this.latitude,
    this.longitude,
  });

  double latitude;
  double longitude;

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        latitude: json["_latitude"].toDouble(),
        longitude: json["_longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_latitude": latitude,
        "_longitude": longitude,
      };
}

class G {
  G({
    this.geohash,
    this.geopoint,
  });

  String geohash;
  Coordinates geopoint;

  factory G.fromJson(Map<String, dynamic> json) => G(
        geohash: json["geohash"],
        geopoint: Coordinates.fromJson(json["geopoint"]),
      );

  Map<String, dynamic> toJson() => {
        "geohash": geohash,
        "geopoint": geopoint.toJson(),
      };
}
