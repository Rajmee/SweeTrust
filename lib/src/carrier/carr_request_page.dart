import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sweet_trust/src/carrier/carr_tracker_map_page.dart';
import 'package:sweet_trust/src/pages/map_tracker_page.dart';
import 'package:sweet_trust/src/widgets/car_req_button.dart';
import 'package:sweet_trust/src/widgets/carr_request_card.dart';
import '../../src/widgets/styles.dart';
import '../../src/widgets/colors.dart';

class CarRequestPage extends StatefulWidget {
  // final String pageTitle;
  // final Product productData;

  // ProductPage({Key key, this.pageTitle, this.productData}) : super(key: key);
  CarRequestPage();

  @override
  _CarRequestPageState createState() => _CarRequestPageState();
}

class _CarRequestPageState extends State<CarRequestPage> {
  String address = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: ListView(
          children: <Widget>[
            Container(
              // margin: EdgeInsets.only(top: ),
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CarReqItemCard("taltola", "Omar Sharif Rajme",
                          "Tangail Chamcham", "2", "120"),
                    ),

                    // Align(
                    //   child: Container(
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: <Widget>[
                    //         Container(
                    //           child: CarReqItemCard(
                    //               "Dhaka",
                    //               "Omar Sharif Rajme",
                    //               "01850017691",
                    //               "Tangail Chamcham",
                    //               "120/kg"),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
