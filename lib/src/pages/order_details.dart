import 'package:flutter/material.dart';
import 'package:sweet_trust/src/widgets/order_details_sweet_info.dart';
import 'package:sweet_trust/src/widgets/order_process_card.dart';
import '../../src/widgets/carrier_info_card.dart';
import '../../src/widgets/call_map_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../src/models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../widgets/styles.dart';
import '../widgets/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderDetailsPage extends StatefulWidget {
  final Order order;
  // final DocumentSnapshot post;
  OrderDetailsPage(this.order);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final firestoreInstance = Firestore.instance;
  DocumentSnapshot snapshot;
  String address = '';
  String areaName;
  String swtName;
  String swtQuantity;
  String orderStatus;
  String swttotalPrice;
  String carPhn;
  String carChrg;
  String latLocation;
  String lngLocation;
  var orderId;
  dynamic data;
  var _orderID;
  double _rating = 4;

  @override
  void initState() {
    super.initState();
    setState(() {
      orderId = widget.order.orderId;
      carPhn = widget.order.carierPhn;
    });
    _getData();
    _getCarrierLocation();
  }

  @override
  Widget build(BuildContext context) {
    areaName = widget.order.areaName;
    swtName = widget.order.name;
    // orderId = widget.order.orderId;
    orderStatus = widget.order.status;
    swtQuantity = widget.order.quantity;
    swttotalPrice = widget.order.price;
    // carPhn = widget.order.carierPhn;
    carChrg = widget.order.carierCharge;

    _orderID = orderId.toString();

    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
          centerTitle: true,
          title: Text("Order Status", style: h4),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: darkText,
            onPressed: () async {
              Navigator.pushReplacementNamed(context, "/mainscreen");
            },
          ),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: OrderProcessCard("$areaName", "$orderStatus",
                            "Tangail Chamcham", "2", "120"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: OrderSweetInfoCard(
                            "$swtName",
                            "$swtQuantity",
                            "$swttotalPrice",
                            "\u{2b51} \u{2b51} \u{2b51} \u{2b51} \u{2b51}"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            orderStatus == "orderPicked" ||
                    orderStatus == "productPicked" ||
                    orderStatus == "shipped"
                ? Container(
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: CarrierInfoCard(
                                  "$carPhn",
                                  "\u{2b51} \u{2b51} \u{2b51} \u{2b51} \u{2b51}",
                                  "$carChrg"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "  No Carrier Found !!!",
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            SizedBox(height: 20.0),
            orderStatus == "orderPicked" || orderStatus == "productPicked"
                ? Container(
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: CallMapCard("$carPhn", "$latLocation",
                                  "$lngLocation", "$orderStatus"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: orderStatus == "shipped"
                                    ? Text(
                                        "  Share your experience !!!",
                                        style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null),
                          ),
                          orderStatus == "shipped"
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: 50, bottom: 20, left: 70.0),
                                  child: SmoothStarRating(
                                    allowHalfRating: false,
                                    // onRatingChanged: (v) {
                                    //   setState(() {
                                    //     _rating = v;
                                    //   });
                                    // },
                                    starCount: 5,
                                    rating: _rating,
                                    size: 50.0,
                                    color: Colors.orange,
                                    borderColor: Colors.orange,
                                  ),
                                )
                              : Container(
                                  child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "   *After got the product please share your expeience.",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                ),
                        ],
                      ),
                    ),
                  ),
            SizedBox(height: 20.0),
          ],
        ));
  }

  _getCarrierLocation() async {
    final response = await http
        .post("http://192.168.0.100:3000/getLocation", body: {"phn": carPhn});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      var orderJson = json.decode(response.body);

      setState(() {
        latLocation = orderJson["latitude"].toString();
        lngLocation = orderJson["longitude"].toString();
      });

      print(orderJson);
      print(latLocation);
      print(lngLocation);

      // return customerModelFromJson(responseString);
    } else {
      return null;
    }
  }

  _getData() async {
    final data = await Firestore.instance
        .collection("ongoinOrders")
        .document('$orderId')
        .get();
    snapshot = data;

    if (orderStatus == "orderPicked") {
      var firebaseUser = await FirebaseAuth.instance.currentUser();
      firestoreInstance
          .collection('orderInfo')
          .document(firebaseUser.phoneNumber)
          .collection('orders')
          .document('$orderId')
          .updateData({
        "orderStatus": "$orderStatus",
      });
    }
  }
}

// class Orders {
//   final String name;
//   final String areaName;
//   final String status;
//   final int orderId;

//   Orders(this.name, this.areaName, this.status, this.orderId);
// }
