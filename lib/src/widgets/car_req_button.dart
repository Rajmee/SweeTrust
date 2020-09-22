import 'package:flutter/material.dart';
import './colors.dart';

// OutlineButton acceptBtn(String text, onPressed) {
//   return OutlineButton(
//     onPressed: onPressed,
//     child: Text(text),
//     textColor: Colors.green,
//     borderSide: BorderSide(color: Colors.green),
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//   );
// }

OutlineButton rejectBtn(String text, onPressed) {
  return OutlineButton(
    onPressed: onPressed,
    child: Text(text),
    textColor: Colors.red,
    borderSide: BorderSide(color: Colors.red),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  );
}

FlatButton acceptBtn(String text, onPressed) {
  return FlatButton(
    onPressed: onPressed,
    child: Text(text),
    textColor: Colors.white,
    color: Colors.green,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  );
}
