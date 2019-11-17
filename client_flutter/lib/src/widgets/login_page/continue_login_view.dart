import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:client_flutter/src/provider/provider_collection.dart'
    show AuthProvider;
import 'package:client_flutter/src/screen/page_collection.dart';
import 'onProcess_allert_view.dart';

void showContinueToLoginDialog({BuildContext context, Widget child}) {
  showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => child,
  );
}

class ContinueToLoginDialog extends StatefulWidget {
  const ContinueToLoginDialog({Key key}) : super(key: key);

  @override
  _ContinueToLoginDialogState createState() => _ContinueToLoginDialogState();
}

class _ContinueToLoginDialogState extends State<ContinueToLoginDialog> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return CupertinoAlertDialog(
      title: const Text('提醒'),
      content: const Text('\n若確定登入此裝置，\n將同步您的個人資料和紀錄到當前裝置\n並清空裝置內原有資訊!'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('放棄登入'),
          onPressed: () {
            // 願意放棄 (使用者放棄登入此裝置)
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
        CupertinoDialogAction(
          // isDefaultAction: true,
          child: const Text('確定登入'),
          onPressed: () {
            // 不願意放棄 (使用者確定要登入此裝置)
            sureToLogin();
          },
        ),
      ],
    );
  }

  sureToLogin() async {
    // 當前登入的使用者是否在行程中
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool paired =
        await authProvider.identifyUserState(authProvider.currentUid);
    debugPrint('$paired');

    // 是
    if (paired) {
      debugPrint('使用者尚在行程中');
      // 提醒使用者尚在行程中，無法更換裝置
      alert();
    } else {
      // 否
      debugPrint('使用者不在行程中');
      // 向後端請求取回該名使用者的資訊並寫入該裝置
      await authProvider.invokeStoreUserInfo(authProvider.jwt);
      // 向後端請求把登入使用者的 userDevice 改成 currentDevice
      authProvider.invokeModifyDevice(
          authProvider.currentDevice, authProvider.currentUid);
      // 將 jwt token 存到 secureStorage
      authProvider.invokeStoreJwtToken(authProvider.jwt);
      // 進入主畫面
      Navigator.pushNamedAndRemoveUntil(
        context,
        Homepage.routeName,
        (Route<dynamic> route) => false,
      );
    }
  }

  void alert() {
    showOnProcessDialog(
      context: context,
      child: const OnProcessDialog(),
    );
  }
}
