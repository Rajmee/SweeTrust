import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sweet_trust/src/enums/auth_mode.dart';
import 'package:sweet_trust/src/models/user_model.dart';
import 'package:sweet_trust/src/scoped-model/main_model.dart';
import 'package:sweet_trust/src/scoped-model/user_model.dart';
import 'package:sweet_trust/src/services/auth_service_signup.dart';
import 'package:sweet_trust/src/widgets/button_google.dart';
import 'package:sweet_trust/src/widgets/button_submit.dart';
import 'package:sweet_trust/src/widgets/create_account_label.dart';
import 'package:sweet_trust/src/widgets/divider.dart';
import 'package:sweet_trust/src/widgets/sweet_trust_title.dart';
import 'package:sweet_trust/src/utils/responsive_builder.dart';
import 'package:sweet_trust/src/widgets/login_account_label.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import '../../src/scoped-model/customer_model.dart';

import 'sigin_page.dart';

class SignUpPage extends StatefulWidget {
  final User user;
  SignUpPage({Key key, this.user}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _username;
  String _phone;
  String _password;
  String confirmPassword = "";
  String _userType = "Customer";
  String error = '';
  String smsCode;
  String verificationId;
  String countryCode = "+88";
  String verify = "Verifying";

  CustomerModel _customerModel;

  bool codeSent = false;

  String defaultFontFamily = 'Roboto-Light.ttf';
  double defaultFontSize = 14;
  double defaultIconSize = 17;

  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // final _formKey = GlobalKey<FormState>();

  Widget _entryField(String title, String inputTitle,
      {bool isPassword = false,
      FormFieldValidator validator,
      ValueChanged onChanged}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
              validator: validator,
              onChanged: onChanged,
              obscureText: isPassword,
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  hintText: inputTitle,
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _signUpFormWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _entryField(
            "Username",
            "username",
            validator: (val) => val.isEmpty ? 'Enter Name' : null,
            onChanged: (val) => _username = val,
          ),
          _entryField(
            "Phone number",
            "phone number",
            validator: (val) =>
                val.length < 11 ? 'Enter a valid phone number' : null,
            onChanged: (val) => _phone = countryCode + val,
          ),
          _entryField(
            "Password",
            "password",
            validator: (val) => val.length < 6
                ? 'Enter a password with more than 6 characters'
                : null,
            onChanged: (val) => _password = val,
            isPassword: true,
          ),
          _entryField("Confirm Password ", "confirm password",
              onChanged: (val) => confirmPassword = val,
              validator: (val) => confirmPassword != _password
                  ? 'Password does not match'
                  : null,
              isPassword: true),
        ],
      ),
    );
  }

  Widget _buildOTPTextField() {
    return TextFormField(
      showCursor: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        prefixIcon: Icon(
          Icons.confirmation_number,
          color: Color(0xFF666666),
          size: defaultIconSize,
        ),
        fillColor: Color(0xFFF2F3F5),
        hintStyle: TextStyle(
            color: Color(0xFF666666),
            fontFamily: defaultFontFamily,
            fontSize: defaultFontSize),
        hintText: "Enter OTP",
      ),
      onChanged: (val) {
        setState(() {
          this.smsCode = val;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                height: sizingInformation.screenSize.height,
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: viewportConstraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            SweetTrust("Sign Up"),
                            SizedBox(
                              height: 15,
                            ),
                            _signUpFormWidget(),
                            SizedBox(
                              height: 15,
                            ),
                            codeSent
                                ? _buildOTPTextField()
                                : SizedBox(
                                    height: 20,
                                  ),
                            ScopedModelDescendant(
                              builder: (BuildContext context, Widget child,
                                  MainModel model) {
                                return ButtonSubmit(
                                  title: codeSent ? 'Verify' : 'Sign up',
                                  onTap: () async {
                                    final CustomerModel customerData =
                                        await createUser(
                                            _username, _phone, _password);
                                    setState(() {
                                      _customerModel = customerData;
                                    });

                                    _customerModel != null
                                        ? verifyPhone(_phone)
                                        // codeSent
                                        //     ? AuthServiceSignUp().signUpWithOTP(
                                        //         smsCode, verificationId)
                                        //     : verifyPhone(_phone)
                                        : _notifyAlert();
                                    // setState(() {
                                    //   loading = true;
                                    // });
                                  },
                                );
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            LoginAccountLabel(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
      },
    ));
  }

  Future<CustomerModel> createUser(
      String name, String phone, String password) async {
    final String apiUrl = "https://reqres.in/api/users"; //change the url code

    final response =
        await http.post(apiUrl, body: {"name": name, "job": phone});

    if (response.statusCode == 201) {
      final String responseString = response.body;
      return customerModelFromJson(responseString);
    } else {
      return null;
    }
  }

  Future<CustomerModel> verifyPhone(_phone) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthServiceSignUp().signUp(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() async {
        this.codeSent = true;

        // if (_formKey.currentState.validate()) {
        //   _formKey.currentState.save();

        //   if (widget.user == null) {
        //     // I wnat to add new Item
        //     final User user = User(
        //       username: _username,
        //       phone: _phone,
        //       password: _password,
        //       userType: _userType,
        //     );
        //     // addUser(user);
        //   }
        // }
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phone,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  // void onSubmit(Function addUser) async {
  //   if (_formKey.currentState.validate()) {
  //     _formKey.currentState.save();

  //     if (widget.user == null) {
  //       // I wnat to add new Item
  //       final User user = User(
  //         username: _username,
  //         phone: _phone,
  //         password: _password,
  //         userType: _userType,
  //       );
  //       bool value = await addUser(user);
  //       if (value) {
  //         Navigator.of(context).pop();
  //         SnackBar snackBar = SnackBar(content: Text("Successfully signup"));
  //         _scaffoldKey.currentState.showSnackBar(snackBar);
  //       } else if (!value) {
  //         Navigator.of(context).pop();
  //         SnackBar snackBar = SnackBar(content: Text("Try again!"));
  //         _scaffoldKey.currentState.showSnackBar(snackBar);
  //       }
  //     }
  //   }
  // }

  _notifyAlert() async {
    Navigator.of(context).pop();
    SnackBar snackBar = SnackBar(content: Text("Try Again!!!"));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
