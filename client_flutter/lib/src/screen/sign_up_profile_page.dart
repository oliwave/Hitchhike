import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'sign_up_profile_verify_page.dart';
import 'package:client_flutter/src/provider/provider_collection.dart';

class SignUpProfilePage extends StatefulWidget {
  static const String routeName = '/sign_up_profile_page';

  SignUpProfilePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SignUpProfilePageState createState() => _SignUpProfilePageState();
}

class _SignUpProfilePageState extends State<SignUpProfilePage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey: to access form

  Map user = {
    'uid': '',
    'password': '',
    'name': '',
    'gender': 0,
    'birthday': '',
  };

  TextEditingController controller = TextEditingController();
  bool isNextBtnEnable = false;
  bool accountExisted = false;
  String title = "註冊";

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
  }

  Future<bool> _isAccountExisted(String account) async {
    final authProvider = Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    accountExisted = await authProvider.identifyRegisteredId(account);

    setState(() {});

    print(accountExisted);
    return accountExisted;
  }

  Future<void> _nextBtnClickListen(String account) async {
    print('onChange is called');

    /// TODO : add comment.
    isNextBtnEnable = !await _isAccountExisted(account);
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text("$title"),
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
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 50.0, right: 30.0, left: 30.0),
                  child: Column(
                    children: <Widget>[
                      Theme(
                        child: uidField(),
                        data: Theme.of(context).copyWith(
                          primaryColor: Colors.teal[600],
                        ),
                      ),
                    ],
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
                          color: isNextBtnEnable
                              ? Colors.teal[600]
                              : Colors.teal[50],
                          onPressed: () {
                            if (_formKey.currentState.validate() &&
                                accountExisted == false) {
                              _formKey.currentState.save();
                              Navigator.push<String>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        VerifyPage(title: "$title"),
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
    );
  }

  Widget uidField() {
    return TextFormField(
      controller: controller,
      autofocus: true,
      keyboardType: TextInputType.emailAddress, // 鍵盤樣式
      decoration: InputDecoration(
        icon: Icon(Icons.email),
        labelText: '帳號',
        hintText: '學校信箱',
        suffixText: '@ncnu.edu.tw',
        suffixStyle: TextStyle(color: Colors.black),
        errorText: accountExisted ? 'Email address has already existed.' : null,
        suffixIcon: GestureDetector(
          onTap: () {
            controller.clear();
            isNextBtnEnable = false;
          },
          child: Icon(controller.text.length > 0 ? Icons.clear : null),
        ),
      ),
      autovalidate: true,
      inputFormatters: [
        WhitelistingTextInputFormatter(RegExp("[a-z,A-Z,0-9]")), //只能輸入數字,字母
        LengthLimitingTextInputFormatter(25), //長度不能超過25
      ],
      onChanged: (term) {
        if (term.length == 9) {
          _nextBtnClickListen(term);
        } else {
          isNextBtnEnable = false;
          accountExisted = false;
          setState(() {});
        }
      },
      onSaved: (String value) {
        user['uid'] = value;
      },
    );
  }
}
