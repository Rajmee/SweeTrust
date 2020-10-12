import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sweet_trust/src/loader/color_loader.dart';
import 'package:sweet_trust/src/scoped-model/carrier_model.dart';
import 'package:sweet_trust/src/screens/main_screen.dart';
import 'package:sweet_trust/src/services/auth_service.dart';
import 'package:sweet_trust/src/services/car_auth_service.dart';
import 'package:sweet_trust/src/widgets/button_google.dart';
import 'package:sweet_trust/src/widgets/button_submit.dart';
import 'package:sweet_trust/src/widgets/car_create_account_label.dart';
import 'package:sweet_trust/src/widgets/create_account_label.dart';
import 'package:sweet_trust/src/widgets/divider.dart';
import 'package:sweet_trust/src/widgets/sweet_trust_title.dart';
import 'package:sweet_trust/src/utils/responsive_builder.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:sweet_trust/src/scoped-model/user_model.dart';
import 'package:http/http.dart' as http;

// final GoogleSignIn googleSignIn = GoogleSignIn();

class CarSignInPage extends StatefulWidget {
  CarSignInPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CarSignInPageState createState() => _CarSignInPageState();
}

class _CarSignInPageState extends State<CarSignInPage> {
  final _formKey = new GlobalKey<FormState>();
  bool loading = false;
  bool _toggleVisibility = true;
  // bool isAuth = false;

  String _phone = '';
  String _password = '';
  String smsCode;
  String verificationId;
  String countryCode = "+88";
  String verify = "Verifying";

  CarrierModel _carrierModel;

  bool codeSent = false;
  bool isbuttonChnage = false;

  String defaultFontFamily = 'Roboto-Light.ttf';
  double defaultFontSize = 14;
  double defaultIconSize = 17;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
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
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: InputDecoration(
                  hintText: inputTitle,
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _buildPhoneTextField() {
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
          Icons.phone,
          color: Color(0xFF666666),
          size: defaultIconSize,
        ),
        fillColor: Color(0xFFF2F3F5),
        hintStyle: TextStyle(
            color: Color(0xFF666666),
            fontFamily: defaultFontFamily,
            fontSize: defaultFontSize),
        hintText: "Enter your mobile number",
      ),
      // onSaved: (String phone) {
      //   this._phone = phone.trim();
      // },
      onChanged: (val) {
        setState(() {
          this._phone = countryCode + val;
        });
      },
      validator: (String phone) {
        String errorMessage;
        if (_phone.length < 18) {
          errorMessage = "Enter a the valid number";
        }
        return errorMessage;
      },
    );
  }

  Widget _buildPasswordTextField() {
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
          Icons.lock_outline,
          color: Color(0xFF666666),
          size: defaultIconSize,
        ),
        suffixIcon: IconButton(
          color: Color(0xFF666666),
          onPressed: () {
            setState(() {
              _toggleVisibility = !_toggleVisibility;
            });
          },
          icon: _toggleVisibility
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
        ),
        fillColor: Color(0xFFF2F3F5),
        hintStyle: TextStyle(
          color: Color(0xFF666666),
          fontFamily: defaultFontFamily,
          fontSize: defaultFontSize,
        ),
        hintText: "Password",
      ),
      obscureText: _toggleVisibility,
      onChanged: (val) {
        setState(() {
          this._password = val;
        });
      },
      validator: (String password) {
        String errorMessage;
        if (password.length < 4) {
          errorMessage = "Enter a password with more than 8 characters";
        }
        return errorMessage;
      },
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
    return loading
        ? ColorLoader()
        : ResponsiveBuilder(
            builder: (context, sizingInformation) {
              return SafeArea(
                child: Scaffold(
                    key: _scaffoldKey,
                    body: LayoutBuilder(
                      key: _formKey,
                      builder: (BuildContext context,
                          BoxConstraints viewportConstraints) {
                        return SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                            height: sizingInformation.screenSize.height,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: viewportConstraints.maxHeight),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SweetTrust("Sign In"),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    _buildPhoneTextField(),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    _buildPasswordTextField(),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    codeSent
                                        ? _buildOTPTextField()
                                        : SizedBox(
                                            height: 20,
                                          ),
                                    Builder(builder: (context) {
                                      return ButtonSubmit(
                                        title: codeSent ? 'Verify' : 'Sign in',
                                        // title: 'Sign in',
                                        onTap: () async {
                                          if (_phone != '' && _password != '') {
                                            if (isbuttonChnage == false) {
                                              final CarrierModel carrierData =
                                                  await loginUser(
                                                      _phone, _password);

                                              setState(() {
                                                _carrierModel = carrierData;
                                              });
                                            } else {
                                              codeSent
                                                  ? CarAuthService()
                                                      .signInWithOTP(smsCode,
                                                          verificationId)
                                                  : verifyPhone(_phone);
                                            }
                                          } else {
                                            showToast(
                                                "Enter the phone and password");
                                          }
                                        },
                                      );
                                    }),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      alignment: Alignment.center,
                                      child: Text('Forgot your password ?',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    DividerWidget(),
                                    CarCreateAccountLabel()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )),
              );
            },
          );
  }

  void showToast(String txt) {
    Fluttertoast.showToast(
        msg: txt,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white);
  }

  Future<CarrierModel> loginUser(String phone, String password) async {
    final response = await http.post("http://192.168.0.100:3000/signIn",
        body: {"phn": phone, "password": password, "type": "carrier"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      if (responseString != "Mismatch") {
        print("Match");
        print(responseString);
        codeSent
            ? CarAuthService().signInWithOTP(smsCode, verificationId)
            : verifyPhone(_phone);
        setState(() {
          isbuttonChnage = true;
        });
      }

      // return customerModelFromJson(responseString);
    } else {
      print("Not Match");
      _notifyAlert();
      return null;
    }
  }

  Future<void> verifyPhone(_phone) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      CarAuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
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

  _notifyAlert() async {
    // Navigator.of(context).pop();
    SnackBar snackBar = SnackBar(content: Text("Invalid phone or password !"));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
