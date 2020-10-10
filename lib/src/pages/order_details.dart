import 'package:flutter/material.dart';
import 'package:sweet_trust/src/widgets/order_details_sweet_info.dart';
import 'package:sweet_trust/src/widgets/order_process_card.dart';
import '../../src/widgets/carrier_info_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../src/models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/styles.dart';
import '../widgets/colors.dart';

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
  var orderId;
  dynamic data;
  var _orderID;

  @override
  void initState() {
    super.initState();
    setState(() {
      orderId = widget.order.orderId;
    });
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    areaName = widget.order.areaName;
    swtName = widget.order.name;
    orderId = widget.order.orderId;
    orderStatus = widget.order.status;
    swtQuantity = widget.order.quantity;
    swttotalPrice = widget.order.price;
    carPhn = widget.order.carierPhn;
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
                  )
          ],
        ));
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
