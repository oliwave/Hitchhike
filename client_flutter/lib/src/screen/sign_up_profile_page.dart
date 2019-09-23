import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../provider/global/auth_provider.dart';
// import 'sign_up_profile_verify_page.dart';
import 'sign_up_profile_verify_page_test.dart';

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
    'email': '',
    'password': '',
    'name': '',
    'gender': '',
    'birthday': '',
  };

  TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: Text("Sign up"),
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
                  padding: EdgeInsets.only(top: 50.0, right: 50.0, left: 50.0),
                  child: Column(
                    children: <Widget>[
                      emailField(),
                      Container(
                          child: Text(
                              'Notice:\n  Please fill in the NCNU\'s email address.\n  And you don\'t need to fill in \'@ncnu.edu.tw\'.'),
                          margin: EdgeInsets.only(top: 35.0)),
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
                            // disabledTextColor: Colors.teal[50],
                            color: Colors.teal,
                            onPressed: () {
                              if (!_formKey.currentState.validate()) {
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

  Widget emailField() {
    return TextFormField(
      scrollPadding: EdgeInsets.all(50.0),
      controller: controller,
      keyboardType: TextInputType.emailAddress, // 鍵盤樣式
      decoration: InputDecoration(
        icon: Icon(
          Icons.email,
          color: Colors.teal[400],
          size: 24.0,
        ),
        hintText: 'Email address',
        // 點擊輸入框時底線樣式
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
            width: 2.0,
          ),
        ),
        suffixText: '@ncnu.edu.tw',
        suffixStyle: TextStyle(color: Colors.black),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.highlight_off,
            color: Colors.grey,
          ),
          onPressed: () {
            controller.clear();
          },
        ),
        // counterText: 'You don\'t need to fill in \'@ncnu.edu.tw\'.',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Can not be empty.';
        } else if (value.contains('@')) {
          return 'You don\'t need to fill in \'@ncnu.edu.tw\'.';
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
        user['email'] = '$value@ncnu.edu.tw';
      },
    );
  }
}
