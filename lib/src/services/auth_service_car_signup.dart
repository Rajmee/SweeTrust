import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweet_trust/src/carrier/carr_signup_page.dart';
import 'package:sweet_trust/src/screens/car_main_screen.dart';

class AuthServiceCarSignUp {
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return CarMainScreen();
        } else {
          return CarSignUpPage();
        }
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signUp(AuthCredential _authCredential) {
    FirebaseAuth.instance.signInWithCredential(_authCredential);
  }

  signUpWithOTP(smsCode, verId) {
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signUp(authCredential);
  }
}
