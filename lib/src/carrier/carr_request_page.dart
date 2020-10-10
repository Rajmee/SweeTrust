import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sweet_trust/src/models/request_model.dart';
import 'package:sweet_trust/src/widgets/carr_request_card.dart';
import '../../src/widgets/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../src/carrier/carr_request_details.dart';

import 'package:http/http.dart' as http;

class CarRequestPage extends StatefulWidget {
  // final String pageTitle;
  // final Product productData;

  // ProductPage({Key key, this.pageTitle, this.productData}) : super(key: key);
  CarRequestPage();

  @override
  _CarRequestPageState createState() => _CarRequestPageState();
}

class _CarRequestPageState extends State<CarRequestPage> {
  String toDeliver;
  String customerPhn;
  String productName;
  String quantity;
  String price;
  String status;
  String expectedDate;
  final DateFormat timeFormet = DateFormat('h:mma');
  final DateFormat dateFormet = DateFormat('dd-MM-yyyy');
  String timeData;
  String datetimeData;
  int orderId;
  DocumentSnapshot snapshot;
  final Geolocator _geolocator = Geolocator();

  Position _currentPosition;
  // var _currentLatPosition;
  // var _currentLngPosition;

  double _currentLatPosition;
  double _currentLngPosition;

  DateTime datetime;

  String lat;
  String lng;

  String cLat;
  String cLng;

  String _currentAddress;

  String googleAPIKey = "AIzaSyAc6p9AIToEJNJ1BU_QG9lXxcOFx6wq2CM";

  GoogleMapController mapController;

  bool isStopped = false;

  @override
  void initState() {
    super.initState();
    _timer();
    getrequestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        child: FutureBuilder(
          future: getrequestData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  semanticsLabel: "Waiting",
                ),
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

                  // DateTime time = new DateFormat('h:mma').parse(expectedDate);
                  // DateTime date =
                  //     new DateFormat('yyyy-MM-dd').parse(expectedDate);
                  datetime =
                      new DateFormat('yyyy-MM-dd HH:mm').parse(expectedDate);

                  // datetimeData = datetime.toString();

                  return GestureDetector(
                    onTap: () => {
                      // navigateToDetail(snapshot.data[index]),
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CarRequestDetailsPage(snapshot.data[index]),
                        ),
                      )
                    },
                    child: CarReqItemCard(
                      toDelivered: toDeliver,
                      customerPhn: customerPhn,
                      productName: productName,
                      productQuantity: quantity,
                      price: price,
                      status: status,
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

  _timer() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (isStopped) {
        timer.cancel();
      }
      _getCurrentLocation();
    });
  }

  _timerOrder() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (isStopped) {
        timer.cancel();
      }
      getrequestData();
    });
  }

  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        _currentLatPosition = position.latitude;
        _currentLngPosition = position.longitude;
        print('CURRENT POS: $_currentPosition');
        print("LatPos: $_currentLatPosition");
        print("LngPos: $_currentLngPosition");
        cLat = _currentLatPosition.toString();
        cLng = _currentLngPosition.toString();
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddress() async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        print(_currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Request>> getrequestData() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    var phone = firebaseUser.phoneNumber;
    final response =
        await http.post("http://192.168.0.100:3000/getNearbyOrders", body: {
      "latitude": "$cLat",
      "longitude": "$cLng",
      // "longitude": "90.4418078",
      // "latitude": "23.747264",
    });

    if (response.statusCode == 200) {
      final String responseString = response.body;

      var requestJson = json.decode(response.body);

      List<Request> requestList = [];

      for (var o in requestJson) {
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
      print(requestList);
      return requestList;

      // return customerModelFromJson(responseString);
    } else {
      return null;
    }
  }
}
