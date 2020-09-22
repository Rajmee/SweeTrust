import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sweet_trust/src/pages/map_tracker_page.dart';
import 'package:sweet_trust/src/pages/sigin_page.dart';
import 'package:sweet_trust/src/pages/success_page.dart';
import '../../src/pages/pickup_location_page.dart';
import '../../src/widgets/colors.dart';
import '../widgets/order_card.dart';
import '../../src/widgets/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class OrderItemPage extends StatefulWidget {
  final DocumentSnapshot post;

  OrderItemPage({this.post});

  @override
  _OrderItemPageState createState() => _OrderItemPageState();
}

class _OrderItemPageState extends State<OrderItemPage> {
  final firestoreInstance = Firestore.instance;
  String phone;
  String swtName;
  String quantity;
  String price;
  String orderNum;
  var _quantiiy;
  var discount = 20;
  var total;
  var tempPrice;

  @override
  void initState() {
    super.initState();
    getPhone();
  }

  @override
  Widget build(BuildContext context) {
    swtName = widget.post.data["sweetName"];
    quantity = widget.post.data["quantity"];
    price = widget.post.data["price"];
    orderNum = widget.post.data["orderNumber"];

    tempPrice = double.parse(price);
    _quantiiy = int.parse(quantity);
    total = (tempPrice - discount) * _quantiiy;
    // total = to + charge;

    return Scaffold(
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
          OrderCard("$swtName", "$quantity", "$price", "$orderNum"),
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
                "\u{09F3} $price",
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
                "Discount",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "\u{09F3} $discount",
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
                "\u{09F3} $total",
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
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => PickupLocationPage(
                        orderNumber: orderNum,
                      )));
              addOnProcessOrder();
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

  getPhone() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();

    String getPhone = firebaseUser.phoneNumber;

    setState(() {
      phone = getPhone;
    });
  }

  addOnProcessOrder() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();

    var phone = firebaseUser.phoneNumber;

    firestoreInstance.collection('onprocessOrders').document(orderNum).setData({
      "orderNumber": "$orderNum",
      "sweetName": "$swtName",
      "quantity": "$quantity",
      "cusPhone": "$phone",
      "price": "$price",
      "totalprice": "$total",
      "pickupLatLocation": "null",
      "pickupLngLocation": "null",
      "pickupAddress": "null",
      "request": "false",
      "productlocation": "null",
      "expectedDeliveryTime": "null",
      "status": "null",
      "carrierName": "null",
      "carrierLocation": "null",
      "orderStatus1": "false",
      "orderStatus2": "false",
      "orderStatus3": "false",
      "orderStatus4": "false",
      "orderStatus5": "false",
    });
  }
}
