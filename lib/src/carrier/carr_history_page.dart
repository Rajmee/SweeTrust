import 'package:flutter/material.dart';
import '../../src/widgets/styles.dart';
import '../../src/widgets/colors.dart';
import '../../src/widgets/map_history_card.dart';

class CarHistoryPage extends StatefulWidget {
  // final String pageTitle;
  // final Product productData;

  // ProductPage({Key key, this.pageTitle, this.productData}) : super(key: key);

  @override
  _CarHistoryPageState createState() => _CarHistoryPageState();
}

class _CarHistoryPageState extends State<CarHistoryPage> {
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
                      child: MapItemCard(
                          "Tangail to Dhaka", "Product: Chamcham", "120/kg"),
                      // child: Container(
                      //   // margin: EdgeInsets.only(top: 90, bottom: 100),
                      //   padding: EdgeInsets.only(top: 20),
                      //   width: MediaQuery.of(context).size.width * 0.85,
                      //   // child: Column(
                      //   //   mainAxisAlignment: MainAxisAlignment.start,
                      //   //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   //   children: <Widget>[

                      //   //   ],
                      //   // ),

                      //   decoration: BoxDecoration(
                      //       color: Colors.greenAccent,
                      //       borderRadius: BorderRadius.circular(10),
                      //       boxShadow: [
                      //         BoxShadow(
                      //             blurRadius: 15,
                      //             spreadRadius: 5,
                      //             color: Color.fromRGBO(0, 0, 0, .05))
                      //       ]),
                      // ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
