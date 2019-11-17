import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:client_flutter/src/provider/provider_collection.dart'
    show AuthProvider;
import 'package:client_flutter/src/screen/page_collection.dart';

void showOnProcessDialog({BuildContext context, Widget child}) {
  showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => child,
  );
}

class OnProcessDialog extends StatelessWidget {
  const OnProcessDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return CupertinoAlertDialog(
      title: const Text('提醒'),
      content: const Text('\n舊有裝置仍在配對中，無法更換裝置!\n請確認後再重新登入此裝置。'),
      actions: <Widget>[
        CupertinoDialogAction(
          // isDefaultAction: true,
          child: const Text('我知道了'),
          onPressed: () {
            // 將 jwt 設為 "logout"
            authProvider.invokeLogout();
            // 終止該方法並且保持在登入畫面等待使用者之後的操作
            Navigator.pushNamedAndRemoveUntil(
              context,
              LoginPage.routeName,
              (Route<dynamic> route) => false,
            );
          },
        ),
      ],
    );
  }
}
