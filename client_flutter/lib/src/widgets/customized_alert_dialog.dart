import 'package:flutter/material.dart';

Future<dynamic> customizedAlertDialog({
  @required BuildContext context,
  @required Widget title,
  @required Widget content,
  @required String confirmButtonName,
  @required VoidCallback confirmCallback,
  String cancelButtonName,
  VoidCallback cancelCallback,
  bool barrierDismissible = true,
}) {
  if ((cancelButtonName != null && cancelCallback != null) ||
      (cancelButtonName == null && cancelCallback == null)) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        actions: <Widget>[
          if (cancelButtonName != null)
            FlatButton(
              child: Text(
                cancelButtonName,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              onPressed: cancelCallback,
            ),
          FlatButton(
            child: Text(confirmButtonName),
            onPressed: confirmCallback,
          )
        ],
        title: title,
        content: content,
      ),
    );
  } else {
    throw Exception(
        'cancelButtonName and cancelCallback must be specified together or not!');
  }
}
