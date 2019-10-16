import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sign_up_profile_name_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PasswordPage extends StatefulWidget {
  PasswordPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey: to access form

  TextEditingController pwdController = TextEditingController();
  TextEditingController checkController = TextEditingController();

  bool isNextBtnEnable = false;

  @override
  void initState() {
    super.initState();
    pwdController.addListener(() => setState(() {}));
    checkController.addListener(() => setState(() {}));
  }

  void _nextBtnClickListen() {
    if (pwdController.text.length > 0 &&
        pwdController.text == checkController.text) {
      isNextBtnEnable = true;
    } else {
      isNextBtnEnable = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Map user = Map.of(ModalRoute.of(context).settings.arguments);
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
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: <Widget>[
                  Theme(
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 40.0, right: 30.0, left: 30.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "設定密碼",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          passwordField(user),
                          SizedBox(height: 25.0),
                          checkPwdField(user),
                        ],
                      ),
                    ),
                    data: Theme.of(context).copyWith(
                      primaryColor: Colors.teal[400],
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
                                isNextBtnEnable ? Colors.teal : Colors.teal[50],
                            onPressed: () {
                              if (_formKey.currentState.validate() &&
                                  isNextBtnEnable) {
                                _formKey.currentState.save();
                                Navigator.push<String>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          NamePage(title: "填寫基本資訊(1/3)"),
                                      settings: RouteSettings(
                                        arguments: user,
                                      ),
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
        ),
      ),
    );
  }

  Widget passwordField(Map user) {
    return TextFormField(
      controller: pwdController,
      autofocus: true,
      obscureText: true, // 密碼輸入後顯示為點
      decoration: InputDecoration(
        icon: Icon(Icons.lock),
        labelText: '密碼',
        hintText: 'Password',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
            width: 2.0,
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            pwdController.clear();
            isNextBtnEnable = false;
          },
          child: Icon(pwdController.text.length > 0 ? Icons.clear : null),
        ),
      ),
      onChanged: (term) {
        _nextBtnClickListen();
      },
      // validator: (value) => value.isEmpty ? 'Can not be empty.' : null,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(40) //限制長度
      ],
      onSaved: (String value) {
        user['password'] = value;
      },
    );
  }

  Widget checkPwdField(Map user) {
    return TextFormField(
      controller: checkController,
      obscureText: true, // 密碼輸入後顯示為點
      decoration: InputDecoration(
        icon: Icon(Icons.lock_outline),
        labelText: '確認密碼',
        hintText: '請再次輸入密碼',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
            width: 2.0,
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            checkController.clear();
            isNextBtnEnable = false;
          },
          child: Icon(checkController.text.length > 0 ? Icons.clear : null),
        ),
      ),
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(40) //限制長度
      ],
      onChanged: (term) {
        _nextBtnClickListen();
        if (pwdController.text.length <= checkController.text.length && pwdController.text != checkController.text) {
          Fluttertoast.showToast(
              msg: "密碼不相符",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      // onSaved: (String value) {
      // },
    );
  }
}
