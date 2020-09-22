import 'package:flutter/material.dart';
import 'package:sweet_trust/src/pages/order_details.dart';
import '../../src/widgets/styles.dart';
import '../../src/widgets/colors.dart';
import '../../src/widgets/order_status_card.dart';

class AllOrderStatusPage extends StatefulWidget {
  // final String pageTitle;
  // final Product productData;

  // ProductPage({Key key, this.pageTitle, this.productData}) : super(key: key);

  @override
  _AllOrderStatusPageState createState() => _AllOrderStatusPageState();
}

class _AllOrderStatusPageState extends State<AllOrderStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
          centerTitle: true,
          title: Text("All Order Status", style: h4),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: darkText,
            onPressed: () async {
              Navigator.pushReplacementNamed(context, "/mainscreen");
            },
          ),
        ),
        body: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => OrderDetailsPage(),
                )),
              },
              // margin: EdgeInsets.only(top: ),
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: AllOrderStatusCard("Tangail to Dhaka",
                          "Product: Balishmishti", "120/kg"),
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
