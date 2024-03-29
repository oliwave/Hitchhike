import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../provider/provider_collection.dart';
import '../screen/page_collection.dart';
import '../widgets/login_page/continue_login_view.dart';
import '../widgets/login_page/userExist_alert_view.dart';
import './page_collection.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login_page';

  const LoginPage();
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _idController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();

  String identifyDevice;
  bool changeToNewDevice; // 判斷當前登入的使用者願不願意放棄轉移裝置

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    final profileProivder = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    String storedUid = profileProivder.getUserId();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: ListView(
            children: <Widget>[
              appName(),
              Form(
                key: _formKey, //設置globalKey，用於後面獲取FormState
                // autovalidate: true, //開啟自動驗證
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Theme(
                      child: TextFormField(
                        autofocus: false,
                        controller: _idController,
                        decoration: InputDecoration(
                          labelText: "帳號",
                          hintText: "學號",
                          suffixStyle: TextStyle(color: Colors.black),
                          icon: Icon(Icons.person),
                        ),
                        // 驗證id
                        validator: (v) {
                          return v.trim().length > 0 ? null : "請輸入帳號";
                        },
                        inputFormatters: [
                          WhitelistingTextInputFormatter(
                            RegExp("[a-z,A-Z,0-9]"),
                          ), //只能輸入數字,字母
                          LengthLimitingTextInputFormatter(10), //長度不能超過9
                        ],
                      ),
                      data: Theme.of(context).copyWith(
                        primaryColor: Colors.teal[400],
                      ),
                    ),
                    Theme(
                      child: TextFormField(
                        controller: _pwdController,
                        decoration: InputDecoration(
                          labelText: "密碼",
                          hintText: "請輸入密碼",
                          icon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        // 驗證pwd
                        validator: (v) {
                          debugPrint(v);
                          return v.trim().length > 5 ? null : "密碼不能少於六位";
                        },
                        inputFormatters: [
                          WhitelistingTextInputFormatter(
                            RegExp("[a-z,A-Z,0-9]"),
                          ), //只能輸入數字,字母
                          LengthLimitingTextInputFormatter(10), //長度不能超過9
                        ],
                      ),
                      data: Theme.of(context).copyWith(
                        primaryColor: Colors.teal[400],
                      ),
                    ),
                    // 登入按鈕
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Container(
                        width: 300.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          onPressed: () async {
                            // TODO: uncomment this when in production mode.
                            // if (!(_formKey.currentState as FormState)
                            //     .validate()) return;

                            final authenticated =
                                await authProvider.invokeLogin(
                              _idController.text,
                              _pwdController.text,
                            );

                            // 登入成功
                            if (authenticated) {
                              debugPrint('登入成功');

                              identifyDevice = await authProvider
                                  .identifyDevice(authProvider.jwt);

                              if (identifyDevice == 'true') {
                                // 使用者在後端紀錄的裝置和現在的裝置相同
                                debugPrint('使用者在後端紀錄的裝置和現在的裝置相同');

                                // 將 jwt token 存到 secureStorage
                                authProvider
                                    .invokeStoreJwtToken(authProvider.jwt);

                                // 直接進入主畫面
                                Navigator.pushNamed(
                                  context,
                                  Homepage.routeName,
                                );
                              } else {
                                debugPrint('使用者在後端紀錄的裝置和現在的裝置不同');

                                // 檢查該裝置是否有其他使用者的痕跡 (uid 是否 不 為 空(null)))
                                if (storedUid != '') {
                                  // 是 (裝置有其他使用者了)
                                  debugPrint('裝置有其他使用者了: $storedUid');
                                  // 提醒使用者該裝置已經有使用者了
                                  _userExistAlert();
                                } else {
                                  // 否 (尚未有使用者使用這台裝置)
                                  debugPrint('尚未有使用者使用這台裝置');

                                  // 使用者在後端紀錄的裝置是否為空值 null (userDevice 是否為 null)
                                  if (identifyDevice == null) {
                                    // 是 => a. 使用者第一次使用我們的應用程式或已無裝置
                                    debugPrint('使用者第一次使用我們的應用程式或已無裝置');
                                    // 向後端請求把登入使用者的 userDevice 設為 currentDevice
                                    authProvider.invokeModifyDevice(
                                      authProvider.currentDevice,
                                      authProvider.jwt,
                                    );

                                    // 向後端請求取回該名使用者的資訊並寫入該裝置
                                    authProvider
                                        .invokeStoreUserInfo(authProvider.jwt);

                                    // 將 jwt token 存到 secureStorage
                                    authProvider
                                        .invokeStoreJwtToken(authProvider.jwt);

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
                                    _continueToLoginAlert();
                                  }
                                }
                              }
                            }
                          },
                          padding: EdgeInsets.all(10),
                          color: Colors.teal[400],
                          child: Text(
                            '登入',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                        width: 300.0,
                        child: FlatButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                            side: BorderSide(color: Colors.teal[400]),
                          ),
                          onPressed: () {
                            String targetRoute;
                            targetRoute = SignUpProfilePage.routeName;
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              targetRoute,
                              (Route<dynamic> route) => false,
                            );
                          },
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '註冊',
                            style: TextStyle(
                              color: Colors.teal[400],
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _userExistAlert() {
    showUserExistDialog(
      context: context,
      child: const UserExistDialog(),
    );
  }

  void _continueToLoginAlert() {
    showContinueToLoginDialog(
      context: context,
      child: const ContinueToLoginDialog(),
    );
  }

  Widget appName() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Image.asset(
            "assets/icons/appname/pickup.png",
            fit: BoxFit.contain,
            color: Colors.teal,
            height: 190.0,
            width: 350.0,
          ),
        ),
      ],
    );
  }
}
