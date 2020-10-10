import 'package:flutter/material.dart';
import 'package:sweet_trust/src/pages/order_details.dart';
import '../../src/widgets/styles.dart';
import '../../src/widgets/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../src/carrier/carr_history_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import '../../src/scoped-model/order_model.dart';
import '../../src/models/request_model.dart';
import '../widgets/request_status.card.dart';
import 'package:http/http.dart' as http;

class CarHistoryPage extends StatefulWidget {
  // final Order order;

  // const CarHistoryPage({Key key, this.order}) : super(key: key);
  // final String pageTitle;
  // final Product productData;

  // ProductPage({Key key, this.pageTitle, this.productData}) : super(key: key);

  @override
  _CarHistoryPageState createState() => _CarHistoryPageState();
}

class _CarHistoryPageState extends State<CarHistoryPage> {
  String phone;
  String toDeliver;
  String customerPhn;
  String productName;
  String quantity;
  String price;
  String status;
  String expectedDate;
  int orderId;
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
                  toDeliver = snapshot.data[index].areaName;
                  customerPhn = snapshot.data[index].phn;
                  productName = snapshot.data[index].notes;
                  quantity = snapshot.data[index].quantity;
                  price = snapshot.data[index].price;
                  status = snapshot.data[index].orderStatus;
                  orderId = snapshot.data[index].orderId;
                  expectedDate = snapshot.data[index].expectedTime;
                  return GestureDetector(
                    onTap: () => {
                      // navigateToDetail(snapshot.data[index]),
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CarHistoryDetailsPage(
                            snapshot.data[index],
                          ),
                        ),
                      )
                    },
                    child: AllRequestStatusCard(
                      sweetName: productName,
                      areaName: toDeliver,
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

  Future<List<Request>> getData() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    var phone = firebaseUser.phoneNumber;
    final response = await http.post(
        "http://192.168.0.100:3000/getOngoinOrders",
        body: {"phn": phone, "type": "carrier"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      var orderJson = json.decode(response.body);

      List<Request> requestList = [];

      for (var o in orderJson) {
        Request request = Request(
            o["areaName"],
            o["phn"],
            o["notes"],
            o["quantity"],
            o["price"],
            o["orderStatus"],
            o["orderId"],
            o["expectedTime"]);
        requestList.add(request);
      }
      // orders.add(OrderModel.fromJson(orderJson));

      print(responseString);
      return requestList;

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
