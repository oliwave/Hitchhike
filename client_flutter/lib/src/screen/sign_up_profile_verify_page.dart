import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../provider/provider_collection.dart' show AuthProvider;
import '../util/validation_handler.dart';
import 'sign_up_profile_password_page.dart';

class VerifyPage extends StatefulWidget {
  VerifyPage({Key key, this.title}) : super(key: key);
  final title;

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  TextEditingController controller = TextEditingController();
  // var hashedrawSixDigits;
  String hashedrawSixDigits;
  bool isVerifyCodePassed = false; // 是否通過驗證
  bool isVerifyBtnEnable = false; // 可不可以驗證
  bool isGetCodeBtnEnable = true; // 可不可以重送驗證碼
  String buttonText = '發送驗證碼';
  Timer _timer;
  int seconds;

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    cancelTimer();
  }

  void _verifyBtnClickListen() {
    setState(() {
      if (controller.text.length == 6 && isVerifyCodePassed == false) {
        isVerifyBtnEnable = true;
      } else {
        isVerifyBtnEnable = false;
      }
    });
  }

  void _getCodeBtnClickListen() {
    setState(() {
      if (isGetCodeBtnEnable) {
        isGetCodeBtnEnable = false;
        startTimer();
        return null; //按鈕禁用
      } else {
        return null;
      }
    });
  }

  //時間格式化，根據總秒數轉換為對應的 mm:ss 格式
  String constructTime(int seconds) {
    // int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return formatTime(minute) + ":" + formatTime(second);
  }

  //數字格式化，將 0~9 的時間轉換為 00~09
  String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  void startTimer() {
    //設定 1 秒回撥一次
    // const period = const Duration(seconds: 1);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      //秒數減一，因為一秒回撥一次
      setState(() {
        seconds--;
      });
      //倒數計時秒數為0，取消計時器
      if (seconds == 0 && isVerifyCodePassed == false) {
        cancelTimer();
        buttonText = "重新發送驗證碼";
        seconds = 120; //重置時間
        isGetCodeBtnEnable = true;
        Fluttertoast.showToast(
          msg: "超過時間，請重新取得驗證碼",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        hashedrawSixDigits = hashedrawSixDigits + "NO";
      } else if (isVerifyCodePassed == true) {
        cancelTimer();
        buttonText = "重新發送驗證碼";
        isGetCodeBtnEnable = false;
        isVerifyBtnEnable = false;
      } else {
        var t = constructTime(seconds); //更新文本内容
        buttonText = "剩餘時間($t)";
      }
    });
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Map user = Map.of(ModalRoute.of(context).settings.arguments);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ),
        title: Text(widget.title),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 點空白收起鍵盤
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 40.0),
                child: Text(
                  "學校信箱驗證",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    verifyCodeField(),
                    Container(
                      child: FlatButton(
                        textColor: isGetCodeBtnEnable
                            ? Colors.teal[600]
                            : Colors.black.withOpacity(0.2),
                        splashColor: isGetCodeBtnEnable
                            ? Colors.white.withOpacity(0.1)
                            : Colors.transparent,
                        onPressed: () async {
                          var now = DateTime.now();
                          // 2分鐘的時間間隔
                          var twoHours =
                              now.add(Duration(minutes: 2)).difference(now);
                          // 總秒數，2分鐘為120秒
                          seconds = twoHours.inSeconds;

                          hashedrawSixDigits =
                              await authProvider.invokeVerifyCode(user['uid']);

                          setState(() {
                            _getCodeBtnClickListen();
                          });
                        },
                        child: Text(
                          "$buttonText",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 30.0),
                width: 300.0,
                child: FlatButton(
                  color: isVerifyBtnEnable ? Colors.teal[600] : Colors.teal[50],
                  padding: EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  onPressed: () {
                    debugPrint("${controller.text}");
                    setState(() {
                      isVerifyCodePassed =
                          ValidationHandler.verifySixDigitsCode(
                        rawSixDigits: controller.text,
                        hashedSixDigits: hashedrawSixDigits,
                      );
                      Fluttertoast.showToast(
                        msg: isVerifyCodePassed == true
                            ? "驗證成功"
                            : "驗證失敗，請重新取得驗證碼",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    });
                  },
                  child: Text("驗  證",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                ),
              ),
              Flexible(
                child: Column(
                  verticalDirection: VerticalDirection.up,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 55.0,
                      child: FlatButton(
                        color: isVerifyCodePassed
                            ? Colors.teal[600]
                            : Colors.teal[50],
                        onPressed: () {
                          if (isVerifyCodePassed) {
                            Navigator.push<String>(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PasswordPage(title: widget.title),
                                  settings: RouteSettings(arguments: user),
                                ));
                          } else {
                            return null;
                          }
                        },
                        child: Text(
                          "下一步",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
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

  Widget verifyCodeField() {
    return Theme(
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              fillColor: Colors.grey[50],
              filled: true,
              border: InputBorder.none,
              alignLabelWithHint: true,
              hintText: ("請輸入六位數驗證碼"),
              hintStyle: TextStyle(
                fontSize: 14,
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  controller.clear();
                  _verifyBtnClickListen();
                },
                child: Icon(controller.text.length > 0 ? Icons.clear : null),
              ),
            ),
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly, // 只能輸入數字
              LengthLimitingTextInputFormatter(6)
            ],
            onChanged: (term) {
              _verifyBtnClickListen();
            },
            onSaved: (value) {},
          ),
        ),
      ),
      data: Theme.of(context).copyWith(
        primaryColor: Colors.teal[600],
      ),
    );
  }
}
