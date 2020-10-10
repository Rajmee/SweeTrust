import "package:flutter/material.dart";
import 'package:sweet_trust/src/widgets/datetime_card.dart';
import 'package:sweet_trust/src/widgets/divider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'car_req_button.dart';

// ignore: must_be_immutable
class CarRequestDetailsCard extends StatelessWidget {
  final String toDeliver;
  final String customerPhn;
  final String productName;
  final String quantity;
  final String price;
  final String status;
  final String orderId;
  final String datetime;

  // TextEditingController deliveryCharge = new TextEditingController();
  String deliverycharge;

  CarRequestDetailsCard(
    this.toDeliver,
    this.customerPhn,
    this.productName,
    this.quantity,
    this.price,
    this.status,
    this.orderId,
    this.datetime,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width * 0.95,
      height: 700.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
              blurRadius: 5.0, offset: Offset(0, 3), color: Colors.black12),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'assets/icons/delivery.png',
                    height: 80.0,
                    width: 80.0,
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text(
                              "To deliver",
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 18.0, top: 2.0),
                            child: Text(
                              toDeliver,
                              style: TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // DividerWidget(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          height: 10,
                          width: MediaQuery.of(context).size.width * 0.84,
                          child: Divider(
                            color: Colors.grey[200],
                            thickness: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // DividerWidget(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Image.asset(
                              'assets/icons/phn.png',
                              height: 20.0,
                              width: 20.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 5.0),
                            child: Text(
                              "$customerPhn",
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Image.asset(
                              'assets/icons/product.png',
                              height: 18.0,
                              width: 18.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 5.0),
                            child: Text(
                              "$productName",
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Image.asset(
                              'assets/icons/quantity.png',
                              height: 20.0,
                              width: 20.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 5.0),
                            child: Text(
                              "$quantity kg",
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Image.asset(
                              'assets/icons/taka.png',
                              height: 20.0,
                              width: 20.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 5.0),
                            child: Text(
                              "$price \u{09F3}",
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          height: 10,
                          width: MediaQuery.of(context).size.width * 0.84,
                          child: Divider(
                            color: Colors.grey[200],
                            thickness: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // DividerWidget(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Text(
                              "Expected Date & Time (24 hours)",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 40.0, top: 10.0),
                            child: Container(
                              height: 120,
                              width: 270,
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: new Center(
                                  child: new Text(
                                    "$datetime",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 50),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          height: 10,
                          width: MediaQuery.of(context).size.width * 0.84,
                          child: Divider(
                            color: Colors.grey[200],
                            thickness: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // DividerWidget(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 25.0, top: 10.0),
                        child: Container(
                          width: 300,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Delivery Charge',
                              hintText: 'Enter Delivery Charge',
                            ),
                            autofocus: false,
                            onChanged: (value) => this.deliverycharge = value,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 130.0, top: 30.0),
                            child: acceptBtn('Accept', () {
                              _pickOrder(orderId, deliverycharge);
                              Navigator.of(context).pop();
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _pickOrder(String order, String deliveryCharge) async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();

    var phone = firebaseUser.phoneNumber;

    final response = await http.post("http://192.168.0.100:3000/pickOrder",
        body: {"phn": phone, "orderId": order, "delCharge": deliveryCharge});

    print(phone);
    print(order);
    if (response.statusCode == 200) {
      final String responseString = response.body;

      if (responseString == "OK") {
        print("Match");
        print(responseString);
      }

      // return customerModelFromJson(responseString);
    } else {
      print("Not Match");
      return null;
    }
  }
}
