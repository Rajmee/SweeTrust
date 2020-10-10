// import 'package:firebase/firebase.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../src/pages/add_sweet_items.dart';
import 'package:sweet_trust/src/pages/history_page.dart';
import 'package:sweet_trust/src/scoped-model/main_model.dart';
import 'package:sweet_trust/src/widgets/header_drawer.dart';
import '../pages/home_page.dart';
import '../pages/order_page.dart';
import '../pages/explore_page.dart';
import '../pages/profile_page.dart';
import '../../src/pages/all_order_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MainScreen extends StatefulWidget {
  final MainModel model;

  // final FirebaseUser user;

  MainScreen({this.model});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;

  // Pages
  HomePage homePage;
  OrderPage orderPage;
  FavoritePage favoritePage;
  ProfilePage profilePage;

  List<Widget> pages;
  Widget currentPage;
  bool isStopped = false;
  String phone;
  String cartCount;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final Firestore _db = Firestore.instance;

  @override
  void initState() {
    homePage = HomePage();
    orderPage = OrderPage();
    favoritePage = FavoritePage(model: widget.model);
    profilePage = ProfilePage();
    pages = [homePage, favoritePage, orderPage, profilePage];
    _timer();
    currentPage = homePage;
    _notificationHandle();
    _saveDeviceToken();
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
                    ? "All Sweets Items"
                    : currentTab == 2 ? "Carts Items" : "Profile",
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  // size: 30.0,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {}),
            IconButton(
              icon: _buildShoppingCart(),
              onPressed: () {},
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              HeaderDrawer(),
              _createDrawerItem(
                  icon: Icons.history,
                  text: 'Your History',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => HistoryPage()));
                    // Navigator.pushReplacementNamed(context, "/History");
                  }),
              _createDrawerItem(
                  icon: Icons.bookmark,
                  text: 'Order Status',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AllOrderStatusPage()));
                    // Navigator.pushReplacementNamed(context, "/History");
                  }),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        tileColor: Colors.grey,
                        title: Text('version 0.0.1'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                Icons.explore,
              ),
              title: Text("Explore"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
              ),
              title: Text("Carts"),
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

  _notificationHandle() async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  Widget _buildShoppingCart() {
    return Stack(
      children: <Widget>[
        Icon(
          Icons.shopping_cart,
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
                "$cartCount",
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

  _timer() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (isStopped) {
        timer.cancel();
      }
      getPhone();
    });
  }

  getPhone() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    String getPhone = firebaseUser.phoneNumber;
    setState(() {
      phone = getPhone;
    });
    await _getItemcount();
  }

  _getItemcount() async {
    final QuerySnapshot qSnap = await Firestore.instance
        .collection('customerData')
        .document(phone)
        .collection('cartItems')
        .getDocuments();
    final int documents = qSnap.documents.length;

    print(documents);

    setState(() {
      cartCount = documents.toString();
    });
  }

  _saveDeviceToken() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();

    String getPhone = firebaseUser.phoneNumber;
    print(getPhone);
    String fcmToken = await _firebaseMessaging.getToken();
    print(fcmToken);

    if (fcmToken != null) {
      var tokens = _db
          .collection('logininfo')
          .document(getPhone)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        // 'platform': Platform, // optional
      });
    }
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
