import "package:flutter/material.dart";
import 'package:sweet_trust/src/widgets/process_handler.dart';
import 'package:intl/intl.dart';

class AllRequestStatusCard extends StatelessWidget {
  final String sweetName;
  final String areaName;
  final String status;
  final int orderId;

  AllRequestStatusCard(
      {this.sweetName, this.areaName, this.status, this.orderId});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMM, y').format(now);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width * 0.95,
      height: 125.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
              blurRadius: 5.0, offset: Offset(0, 3), color: Colors.black12),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 350.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "\u{2688} Deliver to: $areaName",
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Order id ## $orderId",
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              // Container(
              //   width: 200.0,
              //   child: Text("$description"),
              // ),
              // SizedBox(
              //   height: 15.0,
              // ),
              Container(
                width: 350.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "\u{2688} Item: $sweetName",
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.bold),
                    ),
                    SmallButton(btnText: "$status"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
