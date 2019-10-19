import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:client_flutter/src/provider/provider_collection.dart';
import 'sign_up_profile_password_page.dart';

class VerifyPage extends StatefulWidget {
  VerifyPage({Key key, this.title}) : super(key: key);
  final title;

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  TextEditingController controller = TextEditingController();

  var hashedrawSixDigits;
  bool isVerifyCodePassed = false; // 是否通過驗證
  bool isVerifyBtnEnable = false; // 可不可以驗證
  bool isGetCodeBtnEnable = true; // 可不可以重送驗證碼
  String buttonText = '發送驗證碼';
  int count = 5; // 倒計時時間
  Timer timer; // 計時器

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
  }

  void _verifyBtnClickListen() {
    if (controller.text.length == 6) {
      isVerifyBtnEnable = true;
    } else {
      isVerifyBtnEnable = false;
    }
  }

  void _getCodeBtnClickListen() {
    setState(() {
      if (isGetCodeBtnEnable) {
        isGetCodeBtnEnable = false;
        _initTimer();
        return null; //按鈕禁用
      } else {
        return null;
      }
    });
  }

  void _initTimer() {
    timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      count--;
      setState(() {
        if (count == 0) {
          timer.cancel(); //取消計時
          isGetCodeBtnEnable = true;
          count = 5; //重置时间
          buttonText = "重新發送驗證碼";
        } else {
          buttonText = "剩餘時間($count)"; //更新文本内容
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel(); //取消計時器
    timer = null;
    super.dispose();
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
                            ? Colors.teal
                            : Colors.black.withOpacity(0.2),
                        splashColor: isGetCodeBtnEnable
                            ? Colors.white.withOpacity(0.1)
                            : Colors.transparent,
                        onPressed: () {
                          hashedrawSixDigits =
                              authProvider.invokeVerifyCode(user['uid']);
                          setState(() {
                            _getCodeBtnClickListen();
                          });
                        },
                        child: Text(
                          "$buttonText",
                          style: TextStyle(
                            fontSize: 13,
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
                  color: isVerifyBtnEnable ? Colors.teal : Colors.teal[50],
                  padding: EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  onPressed: () {
                    debugPrint("${controller.text}");
                    setState(() {
                      // isVerifyCodePassed = authProvider.checkVerifyCode(
                      //     controller.text, hashedrawSixDigits);

                      // test
                      // if (isVerifyCodePassed == true) {
                      if (controller.text == '123123') {
                        isVerifyCodePassed = true;
                        Fluttertoast.showToast(
                            msg: "驗證成功",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        isVerifyCodePassed = false;
                        Fluttertoast.showToast(
                            msg: "驗證失敗，請重新取得驗證碼",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
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
                        color:
                            isVerifyCodePassed ? Colors.teal : Colors.teal[50],
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
                          "Next",
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
              WhitelistingTextInputFormatter.digitsOnly,
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
        primaryColor: Colors.teal[400],
      ),
    );
  }
}
