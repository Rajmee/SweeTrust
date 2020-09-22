import 'package:flutter/material.dart';

class CarCreateAccountLabel extends StatelessWidget {
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
              Navigator.pushReplacementNamed(context, "/CarSignUp");
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
