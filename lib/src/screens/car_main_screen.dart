import 'package:flutter/material.dart';
import 'package:sweet_trust/src/carrier/carr_history_page.dart';
import 'package:sweet_trust/src/carrier/carr_profile_page.dart';
import 'package:sweet_trust/src/carrier/carr_request_page.dart';
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
  CarTrackerMapPage homePage;
  CarRequestPage requestPage;
  CarHistoryPage historyPage;
  CarProfilePage profilePage;

  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    homePage = CarTrackerMapPage(add: widget.addres);
    requestPage = CarRequestPage();
    historyPage = CarHistoryPage();
    profilePage = CarProfilePage();
    pages = [homePage, requestPage, historyPage, profilePage];

    currentPage = homePage;
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
        // drawer: Drawer(
        //   child: ListView(
        //     padding: EdgeInsets.zero,
        //     children: <Widget>[
        //       HeaderDrawer(),

        //       _createDrawerItem(
        //           icon: Icons.history,
        //           text: 'Your History',
        //           onTap: () =>
        //               Navigator.pushReplacementNamed(context, "/History")),

        //       Expanded(
        //         child: Align(
        //           alignment: Alignment.bottomCenter,
        //           child: Column(
        //             children: <Widget>[
        //               ListTile(
        //                 tileColor: Colors.grey,
        //                 title: Text('version 0.0.1'),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //       // ListTile(
        //       //   onTap: () {
        //       //     Navigator.of(context).pop();
        //       //     Navigator.of(context).push(MaterialPageRoute(
        //       //         builder: (BuildContext context) => AddFoodItem()));
        //       //   },
        //       //   leading: Icon(Icons.list),
        //       //   title: Text(
        //       //     "Add food Item",
        //       //     style: TextStyle(fontSize: 16.0),
        //       //   ),
        //       // )
        //     ],
        //   ),
        // ),
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
