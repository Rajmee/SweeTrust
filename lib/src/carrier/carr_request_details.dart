import 'package:flutter/material.dart';
import 'package:sweet_trust/src/widgets/order_details_sweet_info.dart';
import 'package:sweet_trust/src/widgets/request_details_card.dart';
import '../../src/widgets/carrier_info_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../src/models/request_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../src/carrier/carr_request_page.dart';
import '../widgets/styles.dart';
import '../widgets/colors.dart';
import 'package:intl/intl.dart';

class CarRequestDetailsPage extends StatefulWidget {
  final Request request;

  // final DocumentSnapshot post;
  CarRequestDetailsPage(this.request);

  @override
  _CarRequestDetailsPageState createState() => _CarRequestDetailsPageState();
}

class _CarRequestDetailsPageState extends State<CarRequestDetailsPage> {
  final firestoreInstance = Firestore.instance;
  DocumentSnapshot snapshot;
  String toDeliver;
  String customerPhn;
  String productName;
  String quantity;
  String price;
  String status;
  String expectedDate;
  int orderId;
  DateTime datetime;
  dynamic data;
  var _orderID;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   orderId = widget.order.orderId;
    // });
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    toDeliver = widget.request.areaName;
    customerPhn = widget.request.phn;
    productName = widget.request.notes;
    quantity = widget.request.quantity;
    price = widget.request.price;
    status = widget.request.orderStatus;
    orderId = widget.request.orderId;
    expectedDate = widget.request.expectedTime;

    datetime = new DateFormat('yyyy-MM-dd HH:mm').parse(expectedDate);

    _orderID = orderId.toString();

    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
          centerTitle: true,
          title: Text("Details", style: h4),
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back_ios),
          //   color: darkText,
          //   onPressed: () async {
          //     Navigator.of(context).pop();
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (BuildContext context) => CarRequestPage(),
          //       ),
          //     );
          //     // Navigator.pushReplacementNamed(context, "/mainscreen");
          //   },
          // ),
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
                        child: CarRequestDetailsCard(
                          "$toDeliver",
                          "$customerPhn",
                          "$productName",
                          "$quantity",
                          "$price",
                          "$status",
                          "$orderId",
                          "$datetime",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ));
  }

  _getData() async {
    final data = await Firestore.instance
        .collection("ongoinOrders")
        .document('$orderId')
        .get();
    snapshot = data;
    setState(() {
      status = snapshot.data['orderStatus'];
      print(status);
      print(orderId);
    });
    if (status == "orderPicked") {
      var firebaseUser = await FirebaseAuth.instance.currentUser();
      firestoreInstance
          .collection('orderInfo')
          .document(firebaseUser.phoneNumber)
          .collection('orders')
          .document('$orderId')
          .updateData({
        "orderStatus": "$status",
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
