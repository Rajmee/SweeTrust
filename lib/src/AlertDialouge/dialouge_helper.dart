import '../../src/AlertDialouge/confirmDialouge.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static confirm(context) =>
      showDialog(context: context, builder: (context) => ConfirmationDialog());
}
