import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sign_up_profile_verify_page.dart';

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
    'gender': '',
    'birthday': '',
  };

  TextEditingController controller = TextEditingController();
  bool isButtonEnable = true; // 按鈕是否可以點擊

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }
  void _buttonClickListen() {
    setState(() {
      if (isButtonEnable) {
        isButtonEnable = false;
        return null; //按鈕禁用
      } else {
        return null;
      }
    });
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
        title: Text("Sign Up"),
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
                          primaryColor: Colors.teal[400],
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
                            disabledTextColor: Colors.teal[50],
                            color: Colors.teal,
                            // color: _formKey.currentState.validate()
                            //     ? Colors.teal
                            //     : Colors.teal[50],
                            onPressed: () {
                              if (_formKey.currentState.validate() == false) {
                                return null;
                              } else {
                                _formKey.currentState.save();
                                Navigator.push<String>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          VerifyPage(title: 'Sign Up'),
                                      settings: RouteSettings(
                                        arguments: user,
                                      ),
                                    ));
                              }
                            },
                            child: Text("Verify")),
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
      keyboardType: TextInputType.emailAddress, // 鍵盤樣式
      decoration: InputDecoration(
        icon: Icon(Icons.email),
        labelText: '帳號',
        hintText: '學校信箱',
        // 點擊輸入框時底線樣式
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
            width: 2.0,
          ),
        ),
        suffixText: '@ncnu.edu.tw',
        suffixStyle: TextStyle(color: Colors.black),
        suffixIcon: GestureDetector(
          onTap: () {
            controller.clear();
          },
          child: Icon(controller.text.length > 0 ? Icons.clear : null),
        ),
      ),
      maxLines: 1,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Can not be empty.';
        } else if (value.contains('@')) {
          return '';
        } else {
          return null;
        }
      },
      inputFormatters: [
        WhitelistingTextInputFormatter(RegExp("[a-z,A-Z,0-9]")), //只能輸入數字,字母
        LengthLimitingTextInputFormatter(25), //長度不能超過25
      ],
      onSaved: (String value) {
        user['uid'] = value;
      },
    );
  }
}
