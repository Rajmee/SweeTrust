import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../src/pages/pickup_location_page.dart';
import '../../src/widgets/colors.dart';
import '../widgets/order_card.dart';
import '../../src/widgets/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../src/pages/success_page.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class OrderItemPage extends StatefulWidget {
  // final DocumentSnapshot post;

  final String swtName;
  final String quantity;
  final String price;
  final String cartNum;
  final String area;
  final String lat;
  final String lng;
  final String currenLocality;
  final String timeDate;
  final String imgurl;
  final String expectedTimeDate;
  var currentLat;
  var currentLng;

  OrderItemPage(
      {this.swtName,
      this.quantity,
      this.price,
      this.cartNum,
      this.area,
      this.lat,
      this.lng,
      this.currenLocality,
      this.timeDate,
      this.imgurl,
      this.expectedTimeDate,
      this.currentLat,
      this.currentLng});

  @override
  _OrderItemPageState createState() => _OrderItemPageState();
}

class _OrderItemPageState extends State<OrderItemPage> {
  final firestoreInstance = Firestore.instance;

  String deliveryCharge = "200.0";
  String totalSweetPrice;
  String phone;
  // String deviceToken;
  var currentlat;
  var currentlng;
  var plat;
  var plng;

  var _quantiiy;
  var discount = 20;
  var total;
  var tempPrice;
  var _deliveryCharge;
  var totalPrice;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getPhone();
    // _getToken();
  }

  @override
  Widget build(BuildContext context) {
    tempPrice = double.parse(widget.price);
    _deliveryCharge = double.parse(deliveryCharge);
    _quantiiy = int.parse(widget.quantity);
    totalPrice = tempPrice * _quantiiy;
    total = (tempPrice * _quantiiy);
    totalSweetPrice = total.toString();
    // total = to + charge;

    setState(() {
      currentlat = widget.currentLat;
      currentlng = widget.currentLng;

      plat = widget.lat;
      plng = widget.lng;
    });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        centerTitle: true,
        title: Text("Order Items", style: h4),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios),
        //   color: darkText,
        //   onPressed: () async {
        //     Navigator.pushReplacementNamed(context, "/mainscreen");
        //   },
        // ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          OrderCard(widget.swtName, widget.quantity, widget.price,
              widget.cartNum, widget.imgurl),
        ],
      ),
      bottomNavigationBar: _buildTotalContainer(),
    );
  }

  Widget _buildTotalContainer() {
    return Container(
      height: 250.0,
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Subtotal",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "\u{09F3} $totalPrice",
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Quantity",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "$_quantiiy",
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Deivery charge",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Offer by carrier",
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            height: 2.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Cart Total",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "\u{09F3} $totalSweetPrice",
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          GestureDetector(
            onTap: () async {
              // _getToken();
              _setOngoingOrder();
              await _gosuccessPage();
            },
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: Center(
                child: Text(
                  "Proceed To Checkout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  _gosuccessPage() async {
    try {
      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => SuccessPage()));

      // await _setOngoingOrder();
    } catch (e) {
      print(e);
    }
  }

  // _getToken() async {
  //   var firebaseUser = await FirebaseAuth.instance.currentUser();

  //   var phone = firebaseUser.phoneNumber;

  //   firestoreInstance
  //       .collection('logininfo')
  //       .getDocuments()
  //       .then((querySnapshot) {
  //     querySnapshot.documents.forEach((result) {
  //       firestoreInstance
  //           .collection("logininfo")
  //           .document(phone)
  //           .collection('tokens')
  //           .getDocuments()
  //           .then((querySnapshot) {
  //         querySnapshot.documents.forEach((result) {
  //           // print(result.data);
  //           setState(() {
  //             deviceToken = result.data["token"];
  //           });
  //           print(deviceToken);
  //         });
  //       });
  //     });
  //   });
  // }

  _setOngoingOrder() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();

    var phone = firebaseUser.phoneNumber;

    final response =
        await http.post("http://192.168.0.100:3000/placeOrder", body: {
      "phn": phone,
      "notes": widget.swtName,
      "quantity": widget.quantity,
      "price": "$totalPrice",
      "deliveryCharge": "",
      "areaName": widget.currenLocality,
      "location": "$currentlat" + "," + "$currentlng",
      "pickupCoordinates": "$plat" + "," + "$plng",
      "expectedTime": widget.expectedTimeDate
    });

    firestoreInstance
        .collection('customerData')
        .document(firebaseUser.phoneNumber)
        .collection('cartItems')
        .document(widget.cartNum)
        .delete()
        .then((_) {
      print("success");
    });

    if (response.statusCode == 200) {
      final String responseString = response.body;

      if (responseString == "OK") {
        print("Match");
        print(responseString);
      }

      // return customerModelFromJson(responseString);
    } else {
      print("Not Match");
      _notifyAlert("Order placed !!!");

      return null;
    }
  }

  getPhone() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();

    String getPhone = firebaseUser.phoneNumber;

    setState(() {
      phone = getPhone;
    });
  }

  _notifyAlert(String msg) async {
    // Navigator.of(context).pop();
    SnackBar snackBar = SnackBar(content: Text(msg));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  // addOnProcessOrder() async {
  //   var firebaseUser = await FirebaseAuth.instance.currentUser();

  //   var phone = firebaseUser.phoneNumber;

  // firestoreInstance.collection('onprocessOrders').document(cartNum).setData({
  //   "orderNumber": "$cartNum",
  //   "sweetName": "$swtName",
  //   "quantity": "$quantity",
  //   "cusPhone": "$phone",
  //   "price": "$price",
  //   "totalprice": "$total",
  //   "pickupLatLocation": "null",
  //   "pickupLngLocation": "null",
  //   "pickupAddress": "null",
  //   "request": "false",
  //   "productlocation": "null",
  //   "expectedDeliveryTime": "null",
  //   "status": "null",
  //   "carrierName": "null",
  //   "carrierLocation": "null",
  //   "orderStatus1": "false",
  //   "orderStatus2": "false",
  //   "orderStatus3": "false",
  //   "orderStatus4": "false",
  //   "orderStatus5": "false",
  // });
  // }
}
