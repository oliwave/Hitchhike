import 'package:client_flutter/src/screen/page_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void showDemoDialog({BuildContext context, Widget child}) {
  showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => child,
  );
}

class CupertinoDessertDialog extends StatelessWidget {
  const CupertinoDessertDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('提醒'),
      content: const Text('\n内容尚未儲存，確定要返回?'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('取消'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          // isDefaultAction: true,
          child: const Text('確定'),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              ProfilePage.routeName,
              (Route<dynamic> route) => false,
            );
          },
        ),
      ],
    );
  }
}
