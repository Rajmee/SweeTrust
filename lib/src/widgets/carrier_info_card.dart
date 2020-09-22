import "package:flutter/material.dart";
import '../../src/screens/car_main_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sweet_trust/src/carrier/carr_tracker_map_page.dart';
import 'package:sweet_trust/src/widgets/divider.dart';
import 'package:sweet_trust/src/widgets/process_handler.dart';

import 'car_req_button.dart';

// ignore: must_be_immutable
class CarrierInfoCard extends StatelessWidget {
  final String carName;
  final String carLocation;
  String customerNumber;
  final String carRatings;
  final String carCharge;

  CarrierInfoCard(
      this.carName, this.carLocation, this.carRatings, this.carCharge);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "  Carrier Information",
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
              padding: EdgeInsets.all(26.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Carrier name: $carName",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 10.0,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Carrier location: $carLocation",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 10.0,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Carrier rating: $carRatings",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 10.0,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Carrier charge: $carCharge",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
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
}
