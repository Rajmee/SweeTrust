import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sweet_trust/src/widgets/carr_homepage_card.dart';
import 'package:sweet_trust/src/widgets/order_details_sweet_info.dart';
import 'package:sweet_trust/src/widgets/order_process_card.dart';
import '../../src/widgets/carrier_info_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../src/models/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/styles.dart';
import '../widgets/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class CarHomePage extends StatefulWidget {
  // final Order order;
  // final DocumentSnapshot post;
  CarHomePage();

  @override
  _CarHomePageState createState() => _CarHomePageState();
}

class _CarHomePageState extends State<CarHomePage> {
  final firestoreInstance = Firestore.instance;
  DocumentSnapshot snapshot;
  String address = '';
  String areaName;
  String swtName;
  String swtQuantity;
  String swttotalPrice;
  String carrierName = "loading...";
  var orderId;
  String status;
  dynamic data;
  var _orderID;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription periodicSub;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    // areaName = widget.order.areaName;
    // swtName = widget.order.name;
    // orderId = widget.order.orderId;

    _orderID = orderId.toString();

    return Scaffold(
        backgroundColor: bgColor,
        body: ListView(
          children: <Widget>[
            Container(
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: CarHomePageCart("$carrierName"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(height: 20.0),
            // Container(
            //   child: Center(
            //     child: Stack(
            //       children: <Widget>[
            //         Container(
            //           child: Align(
            //             alignment: Alignment.centerLeft,
            //             child: OrderSweetInfoCard(
            //                 "$swtName",
            //                 "$swtQuantity",
            //                 "$swttotalPrice",
            //                 "\u{2b51} \u{2b51} \u{2b51} \u{2b51} \u{2b51}"),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(height: 20.0),
            // status == "orderPicked"
            //     ? Container(
            //         child: Center(
            //           child: Stack(
            //             children: <Widget>[
            //               Container(
            //                 child: Align(
            //                   alignment: Alignment.centerLeft,
            //                   child: CarrierInfoCard(
            //                       "Bayezid",
            //                       "Mymensingh",
            //                       "\u{2b51} \u{2b51} \u{2b51} \u{2b51} \u{2b51}",
            //                       "200"),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       )
            //     : Container(
            //         child: Center(
            //           child: Stack(
            //             children: <Widget>[
            //               Container(
            //                 child: Align(
            //                   alignment: Alignment.centerLeft,
            //                   child: Text(
            //                     "  No Carrier Found !!!",
            //                     style: TextStyle(
            //                       fontSize: 25.0,
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       )
          ],
        ));
  }

  _getData() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    var phone = firebaseUser.phoneNumber;

    final data = await Firestore.instance
        .collection("carrierInfo")
        .document('$phone')
        .get();
    snapshot = data;

    await setState(() {
      carrierName = snapshot.data['name'];
      print(carrierName);
    });
    // if (status == "orderPicked") {
    //   var firebaseUser = await FirebaseAuth.instance.currentUser();
    //   firestoreInstance
    //       .collection('orderInfo')
    //       .document(firebaseUser.phoneNumber)
    //       .collection('orders')
    //       .document('$orderId')
    //       .updateData({
    //     "orderStatus": "$status",
    //   });
    // }
  }
}
