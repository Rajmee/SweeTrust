import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sweet_trust/src/loader/color_loader.dart';
import 'package:sweet_trust/src/screens/main_screen.dart';
import 'package:sweet_trust/src/services/auth_service.dart';
import 'package:sweet_trust/src/widgets/button_google.dart';
import 'package:sweet_trust/src/widgets/button_submit.dart';
import 'package:sweet_trust/src/widgets/create_account_label.dart';
import 'package:sweet_trust/src/widgets/divider.dart';
import 'package:sweet_trust/src/widgets/sweet_trust_title.dart';
import 'package:sweet_trust/src/utils/responsive_builder.dart';
import 'package:country_code_picker/country_code_picker.dart';

// final GoogleSignIn googleSignIn = GoogleSignIn();

class SignInPage extends StatefulWidget {
  SignInPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = new GlobalKey<FormState>();
  bool loading = false;
  bool _toggleVisibility = true;
  // bool isAuth = false;

  String _phone;
  String _password;
  String smsCode;
  String verificationId;
  String countryCode = "+88";
  String verify = "Verifying";

  bool codeSent = false;

  String defaultFontFamily = 'Roboto-Light.ttf';
  double defaultFontSize = 14;
  double defaultIconSize = 17;

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

  Widget _buildCountryField() {
    return CountryCodePicker(
      initialSelection: 'Bangladesh',
      showCountryOnly: true,
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
      // validator: (String phone) {
      //   String errorMessage;
      //   if (phone.length != 14) {
      //     errorMessage = "Enter a the valid number";
      //   }
      //   return errorMessage;
      // },
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
      onSaved: (String password) {
        _password = password;
      },
      validator: (String password) {
        String errorMessage;
        if (password.length >= 8) {
          errorMessage = "Enter a password with more than 8 characters";
        }
        return errorMessage;
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
                                    // _buildPasswordTextField(),
                                    // SizedBox(
                                    //   height: 20,
                                    // ),
                                    Builder(builder: (context) {
                                      return ButtonSubmit(
                                        title: codeSent ? 'Verify' : 'Sign in',
                                        onTap: () {
                                          codeSent
                                              ? AuthService().signInWithOTP(
                                                  smsCode, verificationId)
                                              : verifyPhone(_phone);
                                          setState(() {
                                            loading = true;
                                          });

                                          // Navigator.pushReplacementNamed(
                                          //     context, "/mainscreen");
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
                                    // ButtonGoogle(
                                    //   onPressed: () async {
                                    //     print("Login with Google");
                                    //     Navigator.pushReplacementNamed(
                                    //         context, "/mainscreen");

                                    //     // locator<GoogleProvider>()
                                    //     //     .login()
                                    //     //     .whenComplete(() {
                                    //     //   Navigator.pushReplacementNamed(
                                    //     //       context, "/Home");
                                    //     // });
                                    //     // locator<GoogleProvider>()
                                    //     //     .createUserInFirestore(context);
                                    //   },
                                    // ),
                                    CreateAccountLabel()
                                  ],
                                ),
                              ),
                            )));
                  },
                )),
              );
            },
          );
  }

  Future<void> verifyPhone(_phone) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
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
}
