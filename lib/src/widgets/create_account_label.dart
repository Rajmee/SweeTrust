import 'package:flutter/material.dart';
import 'package:sweet_trust/src/services/auth_service_signup.dart';
import 'package:page_transition/page_transition.dart';

class CreateAccountLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "You don't have an Account?",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              // Navigator.pushReplacementNamed(context, "/SignUp");
              Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    duration: Duration(seconds: 1),
                    child: AuthServiceSignUp().handleAuth()),
              );
            },
            child: Text(
              "Sign Up",
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
