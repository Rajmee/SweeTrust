import "package:flutter/material.dart";
import '../../src/screens/car_main_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sweet_trust/src/carrier/carr_tracker_map_page.dart';
import 'package:sweet_trust/src/widgets/divider.dart';
import 'package:sweet_trust/src/widgets/process_handler.dart';
import '../../src/pages/product_track_page.dart';
import 'package:url_launcher/url_launcher.dart';

import 'car_req_button.dart';

// ignore: must_be_immutable
class CallMapCard extends StatelessWidget {
  final String carPhn;
  final String latLocation;
  final String lngLocation;
  final String orderStatus;
  String customerNumber;

  CallMapCard(
      this.carPhn, this.latLocation, this.lngLocation, this.orderStatus);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "  Track Product",
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Card(
            elevation: 2.0,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 50.0, top: 30.0),
                          child: trackcallBtn('Map', () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProductTrackPage(
                                        "$latLocation", "$lngLocation"),
                              ),
                            );
                          })),
                      Padding(
                          padding: EdgeInsets.only(left: 80.0, top: 30.0),
                          child: trackcallBtn('Call', () {
                            _callCarrier(carPhn);
                            // Navigator.of(context).pop();
                          })),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _callCarrier(String phonenumber) async {
    var url = "tel:" + phonenumber;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
