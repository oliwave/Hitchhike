import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sign_up_profile_gender_page.dart';

class NamePage extends StatefulWidget {
  NamePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey: to access form

  TextEditingController nameController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.addListener(() {
      setState(() {});
    });
    pwdController.addListener(() {
      setState(() {});
    });
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
                          EdgeInsets.only(top: 50.0, right: 30.0, left: 30.0),
                      child: Column(
                        children: <Widget>[
                          usernameField(user),
                          SizedBox(height: 25.0),
                          passwordField(user),
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
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        icon: Icon(Icons.assignment_ind),
        labelText: '姓名',
        hintText: 'Your name',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
            width: 2.0,
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            nameController.clear();
          },
          child: Icon(nameController.text.length > 0 ? Icons.clear : null),
        ),
      ),
      maxLines: 1,
      validator: (value) => value.isEmpty ? 'Can not be empty.' : null,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(40) //限制長度
      ],
      onSaved: (String value) {
        user['name'] = value;
      },
    );
  }

  Widget passwordField(Map user) {
    return TextFormField(
      controller: pwdController,
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
          },
          child: Icon(pwdController.text.length > 0 ? Icons.clear : null),
        ),
      ),
      maxLines: 1,
      validator: (value) => value.isEmpty ? 'Can not be empty.' : null,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(40) //限制長度
      ],
      onSaved: (String value) {
        user['password'] = value;
      },
    );
  }
}
