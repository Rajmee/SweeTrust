import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../src/pages/success_page.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' show cos, sqrt, asin;

class PickupLocationPage extends StatefulWidget {
  final String cartNumber;
  final String sweetName;
  final String sweettotalPrice;
  final String deleveryCharge;
  final String sweetQuantity;
  PickupLocationPage(
      {this.cartNumber,
      this.sweetName,
      this.sweettotalPrice,
      this.sweetQuantity,
      this.deleveryCharge});
  @override
  _PickupLocationPageState createState() => _PickupLocationPageState();
}

class _PickupLocationPageState extends State<PickupLocationPage> {
  final firestoreInstance = Firestore.instance;
  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(23.4956205, 88.0997553));
  GoogleMapController mapController;
  bool _overlay = false;
  // final bool readOnly = true;

  final Geolocator _geolocator = Geolocator();

  Position _currentPosition;
  LatLng _pickupPosition;

  var _pickupLatPosition;
  var _pickupLngPosition;

  var _currentLatPosition;
  var _currentLngPosition;

  bool address = false;
  bool _isButtonDisable;

  String _currentAddress;
  String _pickupAddress;
  String timeandDate;
  String areaName;

  DateTime selectedDateTime = DateTime.now();

  final DateFormat dateTime = DateFormat('yyyy-MM-dd HH:mm');

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

  createmarker(context) {
    if (setPicupIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              configuration, "assets/icons/pickuppin.png")
          .then((icon) {
        setState(() {
          setPicupIcon = icon;
        });
      });
    }
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        _currentLatPosition = position.latitude;
        _currentLngPosition = position.longitude;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the address
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
        print(_currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  _getPickupLocation(LatLng pos) async {
    setState(() {
      _pickupPosition = pos;
      _pickupLatPosition = pos.latitude;
      _pickupLngPosition = pos.longitude;
      print('PICKUP POS: $_pickupPosition');
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(pos.latitude, pos.longitude),
            zoom: 18.0,
          ),
        ),
      );
    });
    await _getPickupAddress();
  }

  // Method for retrieving the address
  _getPickupAddress() async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
          _pickupPosition.latitude, _pickupPosition.longitude);

      print(_pickupPosition.latitude);

      Placemark place = p[0];

      setState(() {
        _pickupAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        pickupAddressController.text = _pickupAddress;

        areaName = "${place.locality}";

        print(_pickupAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _isButtonDisable = false;
    markers = Set.from([]);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            // _showModalOverlay(),
            // Map View
            GoogleMap(
              onTap: (pos) {
                print(pos);
                // print(pos.latitude);
                Marker m = Marker(
                    markerId: MarkerId("1"), icon: setPicupIcon, position: pos);
                setState(() {
                  markers.add(m);
                  createmarker(context);
                  _getPickupLocation(pos);
                  this.address = true;
                  _isButtonDisable = true;
                });
              },
              markers: markers,
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),

            // Show zoom buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 430),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Show the place input fields & button for
            // showing the route
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
                            'From where',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 10),
                          _textField(
                              label: 'Product Address',
                              hint: 'Product point',
                              // initialValue: _pickupAddress == null
                              //     ? _currentAddress
                              //     : _pickupAddress,
                              initialValue:
                                  address ? _pickupAddress : _currentAddress,
                              // initialValue: _currentAddress,
                              prefixIcon: Icon(Icons.person),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.my_location),
                                onPressed: () {
                                  startAddressController.text = _currentAddress;
                                  _startAddress = _currentAddress;
                                },
                              ),
                              controller: pickupAddressController,
                              width: width,
                              locationCallback: (String value) {
                                setState(() {
                                  _startAddress = value;
                                });
                              }),
                          SizedBox(height: 10),
                          SizedBox(height: 10),
                          Text("Pick the pickup point from the map"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Show current location button
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 80.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: Colors.orange[100], // button color
                          child: InkWell(
                            splashColor: Colors.orange, // inkwell color
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Icon(Icons.my_location),
                            ),
                            onTap: () {
                              mapController.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                      _currentPosition.latitude,
                                      _currentPosition.longitude,
                                    ),
                                    zoom: 18.0,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                            onPressed: (_startAddress != '' &&
                                    _pickupAddress != '' &&
                                    _isButtonDisable)
                                ? () async {
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
                                    });
                                    await _gosuccessPage();
                                  }
                                : null,
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _isButtonDisable
                                    ? "Set address & delivery time"
                                        .toUpperCase()
                                    : 'Pick point'.toUpperCase(),
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

  _gosuccessPage() async {
    try {
      Navigator.of(context).pop();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => SuccessPage()));

      await _setPickupDateTime();
    } catch (e) {
      print(e);
    }
  }

  // _setPickupDateTime() async {
  //   timeandDate = dateTime.format(selectedDateTime);
  //   firestoreInstance
  //       .collection('onprocessOrders')
  //       .document(widget.orderNumber)
  //       .updateData({
  //     "pickupLatLocation": "$_pickupLatPosition",
  //     "pickupLngLocation": "$_pickupLngPosition",
  //     "pickupAddress": "$_pickupAddress",
  //     "expectedDeliveryTime": "$timeandDate"
  //   });
  // }

  _setPickupDateTime() async {
    timeandDate = dateTime.format(selectedDateTime);
    var firebaseUser = await FirebaseAuth.instance.currentUser();

    var phone = firebaseUser.phoneNumber;

    final response =
        await http.post("http://192.168.0.100:3000/placeOrder", body: {
      "phn": phone,
      "notes": widget.sweetName,
      "quantity": widget.sweetQuantity,
      "price": widget.sweettotalPrice,
      "deliveryCharge": widget.deleveryCharge,
      "areaName": "$areaName",
      "location": "$_currentLatPosition" + "," + "$_currentLngPosition",
      "pickupCoordinates": "$_pickupLatPosition" + "," + "$_pickupLngPosition",
      "expectedTime": "$timeandDate",
    });

    firestoreInstance
        .collection('customerData')
        .document(firebaseUser.phoneNumber)
        .collection('cartItems')
        .document(widget.cartNumber)
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

  _notifyAlert(String msg) async {
    // Navigator.of(context).pop();
    SnackBar snackBar = SnackBar(content: Text("Item added to cart !!!"));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
