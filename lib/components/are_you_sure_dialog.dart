import 'package:flutter/material.dart';

Future<bool?> showAreYouSureDialog({
  required BuildContext context,
  String title = "Are you sure?",
  String content = "Do you really want to perform this action?",
  String confirmText = "Confirm",
  String cancelText = "Cancel",
  Color confirmColor = Colors.red,
}) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, // User must tap a button to close
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text(cancelText),
            onPressed: () {
              Navigator.of(context).pop(false); // Returns false
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: confirmColor,
            ),
            child: Text(confirmText),
            onPressed: () {
              Navigator.of(context).pop(true); // Returns true
            },
          ),
        ],
      );
    },
  );
}