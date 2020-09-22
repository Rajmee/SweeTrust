import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SweetTrust extends StatelessWidget {
  String _userType;
  SweetTrust(this._userType);
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: _userType,
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.display1,
          fontSize: 50,
          fontWeight: FontWeight.w700,
          color: Color(0xFFf7418c),
        ),
      ),
    );
  }
}
