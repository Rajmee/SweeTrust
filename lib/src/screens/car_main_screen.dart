import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sweet_trust/src/carrier/carr_history_page.dart';
import 'package:sweet_trust/src/carrier/carr_home_page.dart';
import 'package:sweet_trust/src/carrier/carr_profile_page.dart';
import 'package:sweet_trust/src/carrier/carr_request_page.dart';
import 'package:http/http.dart' as http;
import 'package:sweet_trust/src/carrier/carr_tracker_map_page.dart';

class CarMainScreen extends StatefulWidget {
  final String addres;
  CarMainScreen({this.addres});

  @override
  _CarMainScreenState createState() => _CarMainScreenState();
}

class _CarMainScreenState extends State<CarMainScreen> {
  int currentTab = 0;
  bool turnOnOnline = false;
  // Pages
  CarHomePage homePage;
  CarRequestPage requestPage;
  CarHistoryPage historyPage;
  CarProfilePage profilePage;

  final Geolocator _geolocator = Geolocator();

  Position _currentPosition;
  var _currentLatPosition;
  var _currentLngPosition;
  String _currentAddress;

  String googleAPIKey = "AIzaSyAc6p9AIToEJNJ1BU_QG9lXxcOFx6wq2CM";

  GoogleMapController mapController;

  bool isStopped = false;

  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    homePage = CarHomePage();
    requestPage = CarRequestPage();
    historyPage = CarHistoryPage();
    profilePage = CarProfilePage();
    pages = [homePage, requestPage, historyPage, profilePage];

    currentPage = homePage;
    // _timer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            currentTab == 0
                ? "Sweet Trust"
                : currentTab == 1
                    ? "Request list"
                    : currentTab == 2 ? "History" : "Profile",
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: _buildNotification(),
              onPressed: () {},
            )
          ],
        ),
        resizeToAvoidBottomPadding: false,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTab,
          onTap: (index) {
            setState(() {
              currentTab = index;
              currentPage = pages[index];
            });
          },
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
              ),
              title: Text("Requets"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
              ),
              title: Text("History"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              title: Text("Profile"),
            ),
          ],
        ),
        body: currentPage,
      ),
    );
  }

  _timer() {
    Timer.periodic(Duration(seconds: 20), (timer) {
      if (isStopped) {
        timer.cancel();
      }
      _getCurrentLocation();
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
        _setLocation();
        // mapController.animateCamera(
        //   CameraUpdate.newCameraPosition(
        //     CameraPosition(
        //       target: LatLng(position.latitude, position.longitude),
        //       zoom: 18.0,
        //     ),
        //   ),
        // );
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
        // startAddressController.text = _currentAddress;
        // _startAddress = _currentAddress;
        print(_currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  _setLocation() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();

    var phone = firebaseUser.phoneNumber;

    final response =
        await http.post("http://192.168.0.100:3000/lastLocation", body: {
      "phn": phone,
      "longitude": _currentLngPosition.toString(),
      "latitude": _currentLatPosition.toString(),
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
      return null;
    }
  }

  Widget _buildNotification() {
    return Stack(
      children: <Widget>[
        Icon(
          Icons.notifications_none,
          // size: 30.0,
          color: Theme.of(context).primaryColor,
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: Container(
            height: 12.0,
            width: 12.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.red,
            ),
            child: Center(
              child: Text(
                "5",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _createDrawerItem(
  //     {IconData icon, String text, GestureTapCallback onTap}) {
  //   return ListTile(
  //     title: Row(
  //       children: <Widget>[
  //         Icon(icon),
  //         Padding(
  //           padding: EdgeInsets.only(left: 8.0),
  //           child: Text(text),
  //         )
  //       ],
  //     ),
  //     onTap: onTap,
  //   );
  // }
}
