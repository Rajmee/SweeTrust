import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sweet_trust/src/widgets/button_google.dart';
import 'package:sweet_trust/src/widgets/button_submit.dart';
import 'package:sweet_trust/src/widgets/car_create_account_label.dart';
import 'package:sweet_trust/src/widgets/create_account_label.dart';
import 'package:sweet_trust/src/widgets/divider.dart';
import 'package:sweet_trust/src/widgets/sweet_trust_title.dart';
import 'package:sweet_trust/src/utils/responsive_builder.dart';

// final GoogleSignIn googleSignIn = GoogleSignIn();

class CarSignInPage extends StatefulWidget {
  CarSignInPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CarSignInPageState createState() => _CarSignInPageState();
}

class _CarSignInPageState extends State<CarSignInPage> {
  bool _toggleVisibility = true;
  bool isAuth = false;
  String _email;
  String _password;
  // final _formKey = new GlobalKey<FormState>();
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
      onSaved: (String email) {
        _email = email.trim();
      },
      validator: (String email) {
        String errorMessage;
        if (!email.contains("@")) {
          errorMessage = "Invalid email";
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
      onSaved: (String password) {
        _password = password;
      },
      validator: (String password) {
        String errorMessage;
        if (password.length <= 8) {
          errorMessage = "Enter a password with more than 8 characters";
        }
        return errorMessage;
      },
    );
  }

  // Widget _emailPasswordWidget() {
  //   return Form(
  //     key: _formKey,
  //     child: Column(
  //       children: <Widget>[
  //         _entryField(
  //           "Email",
  //           "Email",
  //           validator: (val) => !EmailValidator.validate(val, true)
  //               ? "Email address is Invalid"
  //               : null,
  //           onChanged: (val) => _email = val,
  //         ),
  //         _entryField(
  //           "Password",
  //           "Password",
  //           isPassword: true,
  //           validator: (val) => val.length < 6
  //               ? 'Enter a password with more than 6 characters'
  //                   'characters'
  //               : null,
  //           onChanged: (val) => _password = val,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return SafeArea(
          child: Scaffold(body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
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
                                height: 20,
                              ),
                              _buildPasswordTextField(),
                              SizedBox(
                                height: 20,
                              ),
                              Builder(builder: (context) {
                                return ButtonSubmit(
                                  title: 'Sign In',
                                  onTap: () async {
                                    Navigator.pushReplacementNamed(
                                        context, "/Carmainscreen");
                                  },
                                );
                              }),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                child: Text('Forgot your password ?',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              ),
                              DividerWidget(),
                              ButtonGoogle(
                                onPressed: () async {
                                  print("Login with Google");
                                  Navigator.pushReplacementNamed(
                                      context, "/mainscreen");

                                  // locator<GoogleProvider>()
                                  //     .login()
                                  //     .whenComplete(() {
                                  //   Navigator.pushReplacementNamed(
                                  //       context, "/Home");
                                  // });
                                  // locator<GoogleProvider>()
                                  //     .createUserInFirestore(context);
                                },
                              ),
                              CarCreateAccountLabel()
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
}
