import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:sweet_trust/src/models/food_model.dart';
import 'package:sweet_trust/src/pages/order_item_page.dart';
import 'package:sweet_trust/src/widgets/datetime_card.dart';
import '../../src/pages/success_page.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' show cos, sqrt, asin;

class ExpectedTimeDatePage extends StatefulWidget {
  final DocumentSnapshot post;

  ExpectedTimeDatePage({this.post});
  @override
  _ExpectedTimeDatePageState createState() => _ExpectedTimeDatePageState();
}

class _ExpectedTimeDatePageState extends State<ExpectedTimeDatePage> {
  String phone;
  String swtName;
  String quantity;
  String price;
  String cartNum;
  String deliveryCharge = "200.0";
  String imgurl;
  String area;
  String lat;
  String lng;
  String time = "0:00";
  String date = "00-00-0000";
  String currenLocality;

  final firestoreInstance = Firestore.instance;
  GoogleMapController mapController;
  bool _overlay = false;
  // final bool readOnly = true;

  final Geolocator _geolocator = Geolocator();

  Position _currentPosition;

  var _currentLatPosition;
  var _currentLngPosition;

  bool address = false;
  bool isbuttonChnage = false;

  String _currentAddress;
  String timeandDate;
  String areaName;

  DateTime selectedDateTime = DateTime.now();

  final DateFormat dateTime = DateFormat('yyyy-MM-dd HH:mm');
  final DateFormat timeFormet = DateFormat('h:mma');
  final DateFormat dateFormet = DateFormat('dd-MM-yyyy');

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();
  final pickupAddressController = TextEditingController();

  String _startAddress = '';

  // String _destinationAddress = '${add}';

  Set<Marker> markers;

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  BitmapDescriptor setPicupIcon;

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  String googleAPIKey = "AIzaSyAc6p9AIToEJNJ1BU_QG9lXxcOFx6wq2CM";

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _textField({
    TextEditingController controller,
    String label,
    String hint,
    String initialValue,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextFormField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        // initialValue: initialValue,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          // enabled: true,
          fillColor: Colors.amberAccent,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue[300],
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    markers = Set.from([]);
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
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
        currenLocality = "${place.locality}";
        print(_currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    swtName = widget.post.data["sweetName"];
    quantity = widget.post.data["quantity"];
    price = widget.post.data["price"];
    cartNum = widget.post.data["cartNumber"];
    imgurl = widget.post.data["imgUrl"];
    area = widget.post.data["area"];
    lat = widget.post.data["lat"];
    lng = widget.post.data["lng"];

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Expected time',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 10),
                          _textField(
                              label: 'Current Address',
                              hint: 'Product point',
                              initialValue: _startAddress,
                              // initialValue: _currentAddress,
                              prefixIcon: Icon(Icons.person),
                              controller: startAddressController,
                              width: width,
                              locationCallback: (String value) {
                                setState(() {
                                  _startAddress = value;
                                });
                              }),
                          SizedBox(height: 10),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ExpectedTimeDateCard(time, date),
              ),
            ),
            // Show current location butto
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 600.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: (_startAddress != '')
                                ? () async {
                                    if (isbuttonChnage == false) {
                                      final selectedDate =
                                          await _selecteDateTime(context);
                                      if (selectedDate == null) {
                                        _notifyAlert("No date selected");
                                      }
                                      final selectedTime =
                                          await _selectTime(context);
                                      if (selectedTime == null) {
                                        _notifyAlert("No time selected");
                                      }

                                      setState(() {
                                        this.selectedDateTime = DateTime(
                                            selectedDate.year,
                                            selectedDate.month,
                                            selectedDate.day,
                                            selectedTime.hour,
                                            selectedTime.minute);
                                        time =
                                            timeFormet.format(selectedDateTime);
                                        date =
                                            dateFormet.format(selectedDateTime);
                                        timeandDate =
                                            dateTime.format(selectedDateTime);
                                        isbuttonChnage = true;
                                      });
                                    } else {
                                      await _gocheckoutPage();
                                    }
                                  }
                                : null,
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                isbuttonChnage
                                    ? "Go".toUpperCase()
                                    : 'Set expected time'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime> _selecteDateTime(BuildContext context) => showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(seconds: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final now = DateTime.now();
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );
  }

  _gocheckoutPage() async {
    try {
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => OrderItemPage(
          swtName: swtName,
          quantity: quantity,
          price: price,
          cartNum: cartNum,
          area: area,
          lat: lat,
          lng: lng,
          currenLocality: currenLocality,
          imgurl: imgurl,
          expectedTimeDate: timeandDate,
          currentLat: _currentLatPosition,
          currentLng: _currentLngPosition,
        ),
      ));

      // await _setPickupDateTime();
    } catch (e) {
      print(e);
    }
  }

  _notifyAlert(String msg) async {
    // Navigator.of(context).pop();
    SnackBar snackBar = SnackBar(content: Text("Item added to cart !!!"));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
