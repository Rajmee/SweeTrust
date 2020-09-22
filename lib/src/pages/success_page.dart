import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../src/pages/all_order_status.dart';
import 'package:sweet_trust/src/widgets/welcome_page_buttons.dart';
import '../../src/widgets/styles.dart';
import '../../src/widgets/colors.dart';
import '../../src/widgets/map_history_card.dart';

class SuccessPage extends StatefulWidget {
  // final String pageTitle;
  // final Product productData;

  // ProductPage({Key key, this.pageTitle, this.productData}) : super(key: key);

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        centerTitle: true,
        title: Text("Request confirmation", style: h4),
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
            // margin: EdgeInsets.only(top: ),
            child: Center(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      // margin: EdgeInsets.only(top: 90, bottom: 100),
                      padding: EdgeInsets.only(top: 20),
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 500.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 80.0,
                                  width: 80.0,
                                  child: Image.asset(
                                    "assets/icons/smile.png",
                                    fit: BoxFit.cover,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Confirm!",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "You will get a notification as soon as possible.",
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          Container(
                            width: 200.0,
                            padding: EdgeInsets.only(top: 200),
                            child: sweetOutlineBtn('Go to order status', () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AllOrderStatusPage()));
                              // Navigator.of(context).pushReplacementNamed('/signup');
                            }),
                          ),
                        ],
                      ),

                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 15,
                                spreadRadius: 5,
                                color: Color.fromRGBO(0, 0, 0, .05))
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
