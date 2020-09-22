import 'package:flutter/material.dart';
import 'package:sweet_trust/src/carrier/carr_signin_page.dart';
import 'package:sweet_trust/src/pages/sigin_page.dart';
import 'package:sweet_trust/src/services/auth_service.dart';
import 'package:sweet_trust/src/widgets/welcome_page_buttons.dart';
import '../../src/widgets/styles.dart';
import '../../src/widgets/colors.dart';
import '../../src/widgets/buttons.dart';

import 'package:page_transition/page_transition.dart';

class WelcomePage extends StatefulWidget {
  final String pageTitle;

  WelcomePage({Key key, this.pageTitle}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/sweetrust.png', width: 220, height: 220),
          // Container(
          //   margin: EdgeInsets.only(bottom: 10, top: 0),
          //   child: Text('Sweetrust!', style: logoStyle),
          // ),
          Container(
            width: 200,
            margin: EdgeInsets.only(bottom: 0),
            child: sweetFlatBtn('As a Customer', () {
              Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    duration: Duration(seconds: 2),
                    child: AuthService().handleAuth()),
              );
            }),
          ),
          Container(
            width: 200,
            padding: EdgeInsets.all(0),
            child: sweetOutlineBtn('As a Carrier', () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      duration: Duration(seconds: 2),
                      child: CarSignInPage()));
              // Navigator.of(context).pushReplacementNamed('/signup');
            }),
          ),
          Container(
            margin: EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Langauage:', style: TextStyle(color: darkText)),
                Container(
                  margin: EdgeInsets.only(left: 6),
                  child: Text('English ›',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)),
                )
              ],
            ),
          )
        ],
      )),
      backgroundColor: bgColor,
    );
  }
}
