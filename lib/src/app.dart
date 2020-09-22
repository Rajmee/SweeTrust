import 'package:flutter/material.dart';
import 'package:sweet_trust/src/carrier/carr_signup_page.dart';
import 'package:sweet_trust/src/pages/history_page.dart';
import 'package:sweet_trust/src/pages/map_tracker_page.dart';
import 'package:sweet_trust/src/pages/sigin_page.dart';
import 'package:sweet_trust/src/pages/signup_page.dart';
import 'package:sweet_trust/src/pages/welcome_page.dart';
import 'package:sweet_trust/src/scoped-model/main_model.dart';
import 'package:sweet_trust/src/screens/car_main_screen.dart';
import 'package:sweet_trust/src/screens/main_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sweet_trust/src/services/auth_service.dart';

class App extends StatelessWidget {
  final MainModel mainModel = MainModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: mainModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Sweet Trust",
        theme: ThemeData(primaryColor: Colors.blueAccent),
        routes: {
          "/": (BuildContext context) => WelcomePage(),
          "/CarSignUp": (BuildContext context) => CarSignUpPage(),
          "/SignUp": (BuildContext context) => SignUpPage(),
          "/History": (BuildContext context) => HistoryPage(),
          "/Carmainscreen": (BuildContext context) => CarMainScreen(),
          "/mainscreen": (BuildContext context) => MainScreen(
                model: mainModel,
              ),
        },
      ),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: AuthService().handleAuth(),
    // );
  }
}
