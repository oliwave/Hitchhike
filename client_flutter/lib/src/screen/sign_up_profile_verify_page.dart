import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sign_up_profile_name_page.dart';

class VerifyPage extends StatefulWidget {
  VerifyPage({Key key, this.title}) : super(key: key);
  final title;
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey: to access form

  var sixDigits = '';

  TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
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
                    child: verifyField(),
                  ),
                  FlatButton(
                    child: Text('驗證'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        print(sixDigits);
                        // authProvider/httprequest
                      } else {
                        return null;
                      }
                    },
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
                                // if (userHashCode != serverHashCode) {
                                // // if (_formKey.currentState.validate()) {
                                //   return null;
                                // } else {
                                Navigator.push<String>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          NamePage(title: "Sign Up"),
                                      settings: RouteSettings(
                                        arguments: user
                                      ),
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
        ),
      ),
    );
  }

  Widget verifyField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: controller,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: '請輸入驗證碼',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
            width: 2.0,
          ),
        ),
      ),
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly, //只能輸入數字
        LengthLimitingTextInputFormatter(6), //限制輸入長度
      ],
      onSaved: (String value) {
        sixDigits = value;
      },
    );
  }
}
