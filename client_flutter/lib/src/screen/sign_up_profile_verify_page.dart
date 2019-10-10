import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'sign_up_profile_name_page.dart';
import 'package:client_flutter/src/provider/provider_collection.dart';

class VerifyPage extends StatefulWidget {
  VerifyPage({Key key, this.title}) : super(key: key);
  final title;
  _VerifyPageState createState() => _VerifyPageState();
}

// class _VerifyPageState extends State<VerifyPage> {
//   final _formKey = GlobalKey<FormState>(); // GlobalKey: to access form

//   var rawSixDigits = '';
//   var verifyPassed = false;

//   TextEditingController controller;

//   @override
//   void initState() {
//     controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Map user = Map.of(ModalRoute.of(context).settings.arguments);
//     final authProivder = Provider.of<AuthProvider>(context, listen: false);
//     final hashedrawSixDigits = authProivder.invokeVerifyCode(user['uid']);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal[400],
//         title: Text(widget.title),
//       ),
//       body: GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onTap: () {
//           // 點空白收起鍵盤
//           FocusScope.of(context).requestFocus(FocusNode());
//         },
//         child: Container(
//           color: Colors.white,
//           child: Form(
//             key: _formKey,
//             child: Center(
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     padding:
//                         EdgeInsets.only(top: 50.0, right: 50.0, left: 50.0),
//                     child: verifyField(),
//                   ),
//                   FlatButton(
//                     child: Text('驗證'),
//                     onPressed: () {
//                       if (_formKey.currentState.validate()) {
//                         _formKey.currentState.save();
//                         print(rawSixDigits);
//                         verifyPassed = authProivder.checkVerifyCode(
//                             rawSixDigits, hashedrawSixDigits);
//                       } else {
//                         return null;
//                       }
//                     },
//                   ),
//                   Flexible(
//                     child: Column(
//                       verticalDirection: VerticalDirection.up,
//                       children: <Widget>[
//                         Container(
//                           width: double.infinity,
//                           height: 55.0,
//                           child: FlatButton(
//                               disabledTextColor: Colors.teal[50], // 按鈕禁用時顏色
//                               color: Colors.teal,
//                               onPressed: () {
//                                 // if (verifyPassed == true) {
//                                   Navigator.push<String>(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (BuildContext context) =>
//                                             NamePage(title: "Sign Up"),
//                                         settings:
//                                             RouteSettings(arguments: user),
//                                       ));
//                                 // } else {
//                                 //   return null;
//                                 // }
//                               },
//                               child: Text("Next")),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget verifyField() {
//     return TextFormField(
//       keyboardType: TextInputType.number,
//       controller: controller,
//       textAlign: TextAlign.center,
//       decoration: InputDecoration(
//         hintText: '請輸入驗證碼',
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.teal,
//             width: 2.0,
//           ),
//         ),
//       ),
//       inputFormatters: [
//         WhitelistingTextInputFormatter.digitsOnly, //只能輸入數字
//         LengthLimitingTextInputFormatter(6), //限制輸入長度
//       ],
//       onSaved: (String value) {
//         rawSixDigits = value;
//       },
//     );
//   }
// }
class _VerifyPageState extends State<VerifyPage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey: to access form
  TextEditingController controller = TextEditingController();

  bool isButtonEnable = true; // 按鈕是否可以點擊
  String buttonText = '發送驗證碼';
  int count = 5; // 倒計時時間
  Timer timer; // 倒計時計時器

  var hashedrawSixDigits;
  bool verifyPassed = false;

  void _buttonClickListen() {
    setState(() {
      if (isButtonEnable) {
        isButtonEnable = false;
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
          isButtonEnable = true;
          count = 5; //重置时间
          buttonText = '發送驗證碼';
        } else {
          buttonText = '剩餘時間($count)'; //更新文本内容
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
                padding: EdgeInsets.only(top: 50.0, left: 10, right: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          onSaved: (value) {},
                          controller: controller,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6)
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.grey[50],
                            filled: true,
                            alignLabelWithHint: true,
                            hintText: ('請輸入驗證碼'),
                            hintStyle: TextStyle(
                              fontSize: 14,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                controller.clear();
                              },
                              child: Icon(controller.text.length > 0
                                  ? Icons.clear
                                  : null),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 120,
                      child: FlatButton(
                        textColor: isButtonEnable // 文字顏色
                            ? Colors.teal
                            : Colors.black.withOpacity(0.2),
                        color: isButtonEnable // 按鈕顏色
                            ? Colors.white
                            : Colors.grey.withOpacity(0.1),
                        splashColor: isButtonEnable
                            ? Colors.white.withOpacity(0.1)
                            : Colors.transparent,
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: isButtonEnable
                                ? Colors.teal[400]
                                : Colors.transparent,
                          ),
                        ),
                        onPressed: () {
                          hashedrawSixDigits =
                              authProvider.invokeVerifyCode(user['uid']);
                          setState(() {
                            _buttonClickListen();
                          });
                        },
                        child: Text(
                          '$buttonText',
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
                  color: Colors.teal[400],
                  padding: EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  onPressed: () {
                    debugPrint('${controller.text}');
                    if (hashedrawSixDigits != null) {
                      if (_formKey.currentState.validate()) {
                        verifyPassed = authProvider.checkVerifyCode(
                            controller.text, hashedrawSixDigits);
                      } else {
                        return null;
                      }
                    } else {
                      return null;
                    }
                  },
                  child: Text('驗  證',
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
                          disabledTextColor: Colors.teal[50], // 按鈕禁用時顏色
                          color: verifyPassed ? Colors.teal : Colors.teal[50],
                          onPressed: () {
                            // if (verifyPassed == false) {
                            //   return null;
                            // } else {

                            Navigator.push<String>(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      NamePage(title: "Sign Up"),
                                  settings: RouteSettings(arguments: user),
                                ));
                            // }
                          },
                          child: Text("Next")),
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
}
