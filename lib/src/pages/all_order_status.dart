import 'package:flutter/material.dart';
import 'package:sweet_trust/src/pages/order_details.dart';
import '../../src/widgets/styles.dart';
import '../../src/widgets/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../src/widgets/order_status_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import '../../src/scoped-model/order_model.dart';
import '../../src/models/order_model.dart';
import 'package:http/http.dart' as http;

class AllOrderStatusPage extends StatefulWidget {
  final Order order;

  const AllOrderStatusPage({Key key, this.order}) : super(key: key);
  // final String pageTitle;
  // final Product productData;

  // ProductPage({Key key, this.pageTitle, this.productData}) : super(key: key);

  @override
  _AllOrderStatusPageState createState() => _AllOrderStatusPageState();
}

class _AllOrderStatusPageState extends State<AllOrderStatusPage> {
  String phone;
  String swtName;
  int orderId;
  String swetPlace;
  String status;
  String areaName;
  String quantity;
  String price;
  String carPhone;
  String carCharge;
  Map data;
  // List<OrderModel> _orderData = List<OrderModel>();

  @override
  void initState() {
    super.initState();
    getPhone();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot documentSnapshot;
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
      body: Container(
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  swtName = snapshot.data[index].name;
                  areaName = snapshot.data[index].areaName;
                  orderId = snapshot.data[index].orderId;
                  status = snapshot.data[index].status;
                  quantity = snapshot.data[index].quantity;
                  price = snapshot.data[index].price;
                  carPhone = snapshot.data[index].carierPhn;
                  carCharge = snapshot.data[index].carierCharge;
                  return GestureDetector(
                    onTap: () => {
                      // navigateToDetail(snapshot.data[index]),
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => OrderDetailsPage(
                            snapshot.data[index],
                          ),
                        ),
                      )
                    },
                    child: AllOrderStatusCard(
                      sweetName: swtName,
                      areaName: areaName,
                      status: status,
                      orderId: orderId,
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Order>> getData() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    var phone = firebaseUser.phoneNumber;
    final response = await http.post(
        "http://192.168.0.100:3000/getOngoinOrders",
        body: {"phn": phone, "type": "customer"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      var orderJson = json.decode(response.body);

      List<Order> orders = [];

      for (var o in orderJson) {
        Order order = Order(
          o["notes"],
          o["areaName"],
          o["orderStatus"],
          o["orderId"],
          o["quantity"],
          o["price"],
          o["carrierPhn"],
          o["deliveryCharge"],
        );
        orders.add(order);
      }
      // orders.add(OrderModel.fromJson(orderJson));

      print(responseString);
      return orders;

      // return customerModelFromJson(responseString);
    } else {
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
}
