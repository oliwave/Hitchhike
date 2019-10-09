import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sign_up_profile_gender_page.dart';

class NamePage extends StatefulWidget {
  NamePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    return new _NamePageState();
  }
}

class _NamePageState extends State<NamePage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey: to access form

  TextEditingController controller;
  TextEditingController controller2;

  @override
  void initState() {
    controller = TextEditingController();
    controller2 = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map user = Map.of(ModalRoute.of(context).settings.arguments);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
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
                  Container(
                    padding:
                        EdgeInsets.only(top: 50.0, right: 50.0, left: 50.0),
                    child: Column(
                      children: <Widget>[
                        usernameField(user),
                        SizedBox(height: 25.0),
                        passwordField(user),
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
                              disabledTextColor: Colors.teal[50], // 按鈕禁用時顏色
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
                                            GenderPage(title: "Sign Up"),
                                        settings: RouteSettings(
                                          arguments: user,
                                        ),
                                      ));
                                }
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
        ),
      ),
    );
  }

  Widget usernameField(Map user) {
    return Theme(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            icon: Icon(
              Icons.assignment_ind, //contacts,
              size: 24.0,
            ),
            hintText: 'Your name',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
                width: 2.0,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.highlight_off,
                color: Colors.grey,
              ),
              onPressed: () {
                controller.clear();
              },
            )),
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(50) //限制長度
        ],
        validator: (value) => value.isEmpty ? 'Can not be empty.' : null,
        onSaved: (String value) {
          user['name'] = value;
        },
      ),
      data: Theme.of(context).copyWith(
        primaryColor: Colors.teal[400],
      ),
    );
  }

  Widget passwordField(Map user) {
    return Theme(
      child: TextFormField(
        controller: controller2,
        obscureText: true, // 密碼輸入後顯示為點
        decoration: InputDecoration(
            icon: Icon(
              Icons.lock_outline,
              size: 24.0,
            ),
            hintText: 'Password',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal,
                width: 2.0,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.highlight_off),
              color: Colors.grey,
              onPressed: () {
                controller2.clear();
              },
            )),
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(50) //限制長度
        ],
        validator: (value) => value.isEmpty ? 'Can not be empty.' : null,
        onSaved: (String value) {
          user['password'] = value;
        },
      ),
      data: Theme.of(context).copyWith(
        primaryColor: Colors.teal[400],
      ),
    );
  }
}
