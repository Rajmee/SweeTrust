import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweet_trust/src/pages/signup_page.dart';
import 'package:sweet_trust/src/screens/main_screen.dart';

class AuthServiceSignUp {
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return MainScreen();
        } else {
          return SignUpPage();
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

  signUpWithOTP(smsCode, verId1) {
    AuthCredential authCredential1 = PhoneAuthProvider.getCredential(
        verificationId: verId1, smsCode: smsCode);
    signUp(authCredential1);
  }
}
