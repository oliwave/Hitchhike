import 'package:client_flutter/src/widgets/login_page/continue_login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:client_flutter/src/provider/provider_collection.dart'
    show AuthProvider, ProfileProvider;
import 'package:client_flutter/src/screen/page_collection.dart';
import '../../screen/login_page.dart';

void showUserExistDialog({BuildContext context, Widget child}) {
  showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => child,
  );
}

class UserExistDialog extends StatelessWidget {
  const UserExistDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    return CupertinoAlertDialog(
      title: const Text('提醒'),
      content: const Text('\n該裝置已有使用者，\n是否確定切換為新的使用者?'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('取消'),
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
        CupertinoDialogAction(
          // isDefaultAction: true,
          child: const Text('確定'),
          onPressed: () {
            // 將原有使用者的 userDevice 設為null
            authProvider.invokeModifyDevice(null, profileProvider.getUserId());
            // 繼續該方法
            judgeDevice(context);
          },
        ),
      ],
    );
  }

  judgeDevice(context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    String identifyDevice = await authProvider.identifyDevice(authProvider.jwt);

    // 使用者在後端紀錄的裝置是否為空值 null (userDevice 是否為 null)
    if (identifyDevice == null) {
      // 是 => a. 使用者第一次使用我們的應用程式或已無裝置
      debugPrint('使用者第一次使用我們的應用程式或已無裝置');
      // 向後端請求把登入使用者的 userDevice 設為 currentDevice
      authProvider.invokeModifyDevice(
          authProvider.currentDevice, authProvider.currentUid);
      // 向後端請求取回該名使用者的資訊並寫入該裝置
      await authProvider.invokeStoreUserInfo(authProvider.jwt);

      // 將 jwt token 存到 secureStorage
      authProvider.invokeStoreJwtToken(authProvider.jwt);

      // 進入主畫面
      Navigator.pushNamedAndRemoveUntil(
        context,
        Homepage.routeName,
        (Route<dynamic> route) => false,
      );
    } else {
      // 否 => b. 使用者使用過且想要登入其他裝置
      debugPrint('使用者使用過且想要登入其他裝置');
      // 告知當前登入的使用者若想要登入此裝置會需要… (同步您的個人資料和紀錄到當前裝置、清除原先裝置裡的資訊)
      _continueToLoginAlert(context);
    }
  }

  void _continueToLoginAlert(context) {
    showContinueToLoginDialog(
      context: context,
      child: const ContinueToLoginDialog(),
    );
  }
}
