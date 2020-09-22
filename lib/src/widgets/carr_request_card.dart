import "package:flutter/material.dart";
import '../../src/screens/car_main_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sweet_trust/src/carrier/carr_tracker_map_page.dart';
import 'package:sweet_trust/src/widgets/divider.dart';
import 'package:sweet_trust/src/widgets/process_handler.dart';

import 'car_req_button.dart';

class CarReqItemCard extends StatelessWidget {
  final String toDelivered;
  final String customerName;
  String customerNumber;
  final String productName;
  final String productunit;
  final String price;

  CarReqItemCard(this.toDelivered, this.customerName, this.productName,
      this.productunit, this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width * 0.95,
      height: 300.0,
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
          //   decoration:
          //       BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'assets/icons/delivery.png',
                    height: 80.0,
                    width: 80.0,
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Container(
                          height: 60,
                          child: VerticalDivider(
                            color: Colors.black,
                            thickness: 2,
                            indent: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text(
                              "Delivery to",
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 18.0, top: 2.0),
                            child: Text(
                              toDelivered,
                              style: TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Column(
                  //   children: <Widget>[
                  //     Padding(
                  //       padding: EdgeInsets.only(left: 60.0),
                  //       child: Container(
                  //         height: 150,
                  //         child: VerticalDivider(
                  //           color: Colors.black,
                  //           thickness: 2,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 13.0),
                            child: Image.asset(
                              'assets/icons/customer1.png',
                              height: 20.0,
                              width: 20.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 5.0),
                            child: Text(
                              customerName,
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 13.0),
                            child: Image.asset(
                              'assets/icons/item.png',
                              height: 20.0,
                              width: 20.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 5.0),
                            child: Text(
                              productName,
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 13.0),
                            child: Image.asset(
                              'assets/icons/kg.png',
                              height: 20.0,
                              width: 20.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 5.0),
                            child: Text(
                              "$productunit kg",
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 13.0),
                            child: Image.asset(
                              'assets/icons/tk.png',
                              height: 20.0,
                              width: 20.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 5.0),
                            child: Text(
                              "$price/kg",
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                // padding: EdgeInsets.only(right: 20),
                width: 330,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Container(
                        width: 140,
                        child: rejectBtn('Cancel', () {}),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      width: 150,
                      child: acceptBtn('Accept', () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => CarMainScreen(
                                  addres: toDelivered,
                                )));
                        // Navigator.pushReplacement(
                        //     context,
                        //     PageTransition(
                        //         type: PageTransitionType.leftToRightWithFade,
                        //         duration: Duration(seconds: 1),
                        //         child: CarTrackerMapPage()));
                      }),
                    ),
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
