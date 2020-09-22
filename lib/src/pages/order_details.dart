import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sweet_trust/src/carrier/carr_tracker_map_page.dart';
import 'package:sweet_trust/src/pages/map_tracker_page.dart';
import 'package:sweet_trust/src/widgets/car_req_button.dart';
import 'package:sweet_trust/src/widgets/carr_request_card.dart';
import 'package:sweet_trust/src/widgets/order_process_card.dart';
import '../../src/widgets/carrier_info_card.dart';
import '../widgets/styles.dart';
import '../widgets/colors.dart';

class OrderDetailsPage extends StatefulWidget {
  // final String pageTitle;
  // final Product productData;

  // ProductPage({Key key, this.pageTitle, this.productData}) : super(key: key);
  OrderDetailsPage();

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  String address = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
          centerTitle: true,
          title: Text("Order Status", style: h4),
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
            Container(
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: OrderProcessCard(
                            "Mymensingh",
                            "Omar Sharif Rajme",
                            "Tangail Chamcham",
                            "2",
                            "120"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CarrierInfoCard(
                            "Bayezid",
                            "Mymensingh",
                            "\u{2b51} \u{2b51} \u{2b51} \u{2b51} \u{2b51}",
                            "200"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
