import 'package:flutter/material.dart';
import 'package:sweet_trust/src/carrier/carr_signin_page.dart';

class CarLoginAccountLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Do you already have an account?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CarSignInPage()));
            },
            child: Text(
              'To log in',
              style: TextStyle(
                  color: Color(0xFFf7418c),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
