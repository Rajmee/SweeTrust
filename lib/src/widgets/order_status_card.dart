import "package:flutter/material.dart";
import 'package:sweet_trust/src/widgets/process_handler.dart';
import 'package:intl/intl.dart';

class AllOrderStatusCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;

  AllOrderStatusCard(this.title, this.description, this.price);

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
          // Container(
          //   margin: EdgeInsets.only(right: 10.0),
          //   width: 140.0,
          //   height: 90.0,
          //   decoration: BoxDecoration(
          //       image: DecorationImage(
          //           image: AssetImage("assets/images/map.jpg"),
          //           fit: BoxFit.cover),
          //       borderRadius: BorderRadius.circular(10.0)),
          // ),
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
                      "\u{2688} $title",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$formattedDate",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
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
                      "\u{2688} $description",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SmallButton(btnText: "Processing"),
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
