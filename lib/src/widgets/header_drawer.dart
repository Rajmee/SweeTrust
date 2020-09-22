// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HeaderDrawer extends StatelessWidget {
  // final String phone;

  // HeaderDrawer(this.phone);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/drawer.png'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("SWEET TRUST",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w500))),
          // Column(
          //   Text(
          //     "Delivered to: $toDelivered",
          //     style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          //   ),
          //   Text(
          //     "Delivered to: $toDelivered",
          //     style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          //   ),
          // ),
        ]));
  }
}
