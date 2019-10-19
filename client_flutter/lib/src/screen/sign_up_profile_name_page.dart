import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sign_up_profile_gender_page.dart';

class NamePage extends StatefulWidget {
  NamePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey: to access form

  TextEditingController nameController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  bool isNextBtnEnable = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(() => setState(() {}));
    pwdController.addListener(() => setState(() {}));
  }

  void _nextBtnClickListen() {
    if (nameController.text.length > 0) {
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
                          EdgeInsets.only(top: 50.0, right: 30.0, left: 30.0),
                      child: Column(
                        children: <Widget>[
                          usernameField(user),
                        ],
                      ),
                    ),
                    data: Theme.of(context).copyWith(
                      primaryColor: Colors.teal[600],
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
                                isNextBtnEnable ? Colors.teal[600] : Colors.teal[50],
                            onPressed: () {
                              if (_formKey.currentState.validate() &&
                                  isNextBtnEnable) {
                                _formKey.currentState.save();
                                Navigator.push<String>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          GenderPage(title: "填寫基本資訊(2/3)"),
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

  Widget usernameField(Map user) {
    return TextFormField(
      controller: nameController,
      autofocus: true,
      decoration: InputDecoration(
        icon: Icon(Icons.assignment_ind),
        labelText: '姓名',
        hintText: '請輸入中文姓名',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal[600],
            width: 2.0,
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            nameController.clear();
            isNextBtnEnable = false;
          },
          child: Icon(nameController.text.length > 0 ? Icons.clear : null),
        ),
      ),
      // validator: (value) => value.isEmpty ? 'Can not be empty.' : null,
      inputFormatters: <TextInputFormatter>[
        // WhitelistingTextInputFormatter(RegExp("[\u4e00-\u9fa5]|")), // 限制輸入中文
        WhitelistingTextInputFormatter(RegExp("[a-zA-Z]|[\u4e00-\u9fa5]|")),
        LengthLimitingTextInputFormatter(40), //限制長度
      ],
      onChanged: (term) {
        _nextBtnClickListen();
      },
      onSaved: (String value) {
        user['name'] = value;
      },
    );
  }
}
