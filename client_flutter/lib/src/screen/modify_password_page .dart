import 'package:client_flutter/src/provider/provider_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ModifyPasswordPage extends StatefulWidget {
  @override
  _ModifyPasswordPageState createState() => _ModifyPasswordPageState();
}

class _ModifyPasswordPageState extends State<ModifyPasswordPage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey: to access form

  TextEditingController pwdController = TextEditingController();
  TextEditingController newpwdController = TextEditingController();
  TextEditingController checkController = TextEditingController();

  String oldPwd;
  String newPassword;
  bool samePwd;

  @override
  void initState() {
    super.initState();
    pwdController.addListener(() => setState(() {}));
    newpwdController.addListener(() => setState(() {}));
    checkController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final jwtToken = authProvider.jwt;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[600],
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                oldPwd = await profileProvider.getPassword();
                print('$oldPwd');
                if (pwdController.text != oldPwd) {
                  Fluttertoast.showToast(
                    msg: "舊密碼錯誤",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else if (newpwdController.text != checkController.text) {
                  Fluttertoast.showToast(
                      msg: "新密碼不相符",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  print("$newPassword");
                  await profileProvider.invokeModifyPassword(newPassword, jwtToken);
                  Navigator.pop(context);
                }
              }
            },
            child: Text(
              "儲存",
              style: TextStyle(fontSize: 16.0),
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
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
                          oldPasswordField(),
                          SizedBox(height: 25.0),
                          newPasswordField(),
                          SizedBox(height: 25.0),
                          checkPwdField(),
                        ],
                      ),
                    ),
                    data: Theme.of(context).copyWith(
                      primaryColor: Colors.teal[600],
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

  Widget oldPasswordField() {
    return TextFormField(
      controller: pwdController,
      autofocus: true,
      obscureText: true, // 密碼輸入後顯示為點
      decoration: InputDecoration(
        icon: Icon(Icons.lock),
        labelText: '目前密碼',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal[600],
            width: 2.0,
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            pwdController.clear();
          },
          child: Icon(pwdController.text.length > 0 ? Icons.clear : null),
        ),
      ),
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter(RegExp("[a-zA-Z]|[0-9]")), // 只能輸入字母或數字
        LengthLimitingTextInputFormatter(20), //限制長度
      ],
    );
  }

  Widget newPasswordField() {
    return TextFormField(
      controller: newpwdController,
      obscureText: true, // 密碼輸入後顯示為點
      decoration: InputDecoration(
        icon: Icon(Icons.lock_outline),
        labelText: '新密碼',
        hintText: '請輸入6-20位英數字',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal[600],
            width: 2.0,
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            newpwdController.clear();
          },
          child: Icon(newpwdController.text.length > 0 ? Icons.clear : null),
        ),
      ),
      validator: (value) => value.length < 6 ? '密碼不能小於六位數' : null,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter(RegExp("[a-zA-Z]|[0-9]")), // 只能輸入字母或數字
        LengthLimitingTextInputFormatter(20), //限制長度
      ],
      onSaved: (String value) {
        newPassword = newpwdController.text;
      },
    );
  }

  Widget checkPwdField() {
    return TextFormField(
      controller: checkController,
      obscureText: true, // 密碼輸入後顯示為點
      decoration: InputDecoration(
        icon: Icon(Icons.lock_outline),
        labelText: '確認新密碼',
        hintText: '請再次輸入新密碼',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal[600],
            width: 2.0,
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            checkController.clear();
          },
          child: Icon(checkController.text.length > 0 ? Icons.clear : null),
        ),
      ),
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter(RegExp("[a-zA-Z]|[0-9]")), // 只能輸入字母或數字
        LengthLimitingTextInputFormatter(40) //限制長度
      ],
    );
  }
}
