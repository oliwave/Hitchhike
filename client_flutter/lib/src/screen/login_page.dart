import 'package:client_flutter/src/provider/provider_collection.dart';
import 'package:client_flutter/src/screen/page_collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'page_collection.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login_page';

  const LoginPage();
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _idController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final authProivder = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: ListView(children: <Widget>[
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: '\nhitchhick\n',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 40,
                    color: Colors.teal[400],
                  ),
                ),
              ),
              Form(
                key: _formKey, //設置globalKey，用於後面獲取FormState
                // autovalidate: true, //開啟自動驗證
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Theme(
                      child: TextFormField(
                        autofocus: false,
                        controller: _idController,
                        decoration: InputDecoration(
                            labelText: "帳號",
                            hintText: "學校信箱",
                            icon: Icon(Icons.person)),
                        // 驗證id
                        validator: (v) {
                          return v.trim().length > 0 ? null : "請輸入帳號";
                        },
                      ),
                      data: Theme.of(context).copyWith(
                        primaryColor: Colors.teal[400],
                      ),
                    ),
                    Theme(
                      child: TextFormField(
                        controller: _pwdController,
                        decoration: InputDecoration(
                            labelText: "密碼",
                            hintText: "請輸入密碼",
                            icon: Icon(Icons.lock)),
                        obscureText: true,
                        //驗證pwd
                        validator: (v) {
                          print(v);
                          return v.trim().length > 5 ? null : "密碼不能少於六位";
                        },
                      ),
                      data: Theme.of(context).copyWith(
                        primaryColor: Colors.teal[400],
                      ),
                    ),
                    // 登入按鈕
                    Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Container(
                          width: 300.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                            onPressed: () async {
                              final authenticated =
                                  await authProivder.invokeLogin(
                                _idController.text,
                                _pwdController.text,
                              );

                              if (authenticated &&
                                  (_formKey.currentState as FormState)
                                      .validate()) {
                                Navigator.pushNamed(
                                  context,
                                  Homepage.routeName,
                                );
                              }
                            },
                            padding: EdgeInsets.all(10),
                            color: Colors.teal[400],
                            child: Text('登入',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                )),
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Container(
                          width: 300.0,
                          child: FlatButton(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                                side: BorderSide(color: Colors.teal[400])),
                            onPressed: () {
                              String targetRoute;
                              targetRoute = SignUpProfilePage.routeName;
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                targetRoute,
                                (Route<dynamic> route) => true,
                              );
                            },
                            padding: EdgeInsets.all(10),
                            child: Text('註冊',
                                style: TextStyle(
                                  color: Colors.teal[400],
                                  fontSize: 18.0,
                                )),
                          ),
                        )),
                  ],
                ),
              ),
            ])),
      ),
    );
  }
}
