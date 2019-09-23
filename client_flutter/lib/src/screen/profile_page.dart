// get jwt
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile_page';

  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>(); // GlobalKey: to access form

  String name = '';
  String gender = '';
  String birthday = '';
  String star = '';
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: Text('編輯個人檔案'),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {},
            child: Text("完成"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.teal[400],
                        image: DecorationImage(
                          image: AssetImage(''
                              //Utils.getImgPath(''),
                              ),
                        ),
                      ),
                    ),
                    FlatButton(
                      child: Text('上傳大頭貼照'),
                      onPressed: () {
                        // 上傳照片
                      },
                    ),
                    nameField(),
                    genderField(),
                    birthdayField(),
                    starField(),
                    emailField(),
                    Container(margin: EdgeInsets.only(top: 25.0)),
                    submitButton(),
                  ],
                ),
              ),
            ],
          )
        ),
    );
  }

  Widget nameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '姓名',
        hintText: '',
      ),
      onSaved: (String value) {
        name = value;
      },
    );
  }

  Widget genderField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '性別',
        hintText: '',
      ),
      onSaved: (String value) {
        gender = value;
      },
    );
  }

  var _chooseDate;
  _showDataPicker() async {
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1870),
      lastDate: DateTime(2050),
    );
    setState(() {
      this._chooseDate = date.toString().split(" ")[0];
    });
  }

  var _time;
  Widget birthdayField() {
    return Column(
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.datetime, // 鍵盤樣式
          decoration: InputDecoration(
            labelText: '生日',
            hintText: '',
          ),
          onSaved: (String value) {
            birthday = value;
          },
        ),
        RaisedButton(
          child: Text(_time == null ? '選擇日期' : _time),
          onPressed: () => _showDataPicker(),
        ),
      ],
    );
  }

  Widget starField() {
    return TextFormField(
      // textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: '星座',
        hintText: '',
      ),
      onSaved: (String value) {
        star = value;
      },
    );
  }

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress, // 鍵盤樣式
      decoration: InputDecoration(
        labelText: 'E-mail',
        hintText: '',
      ),
      onSaved: (String value) {
        email = value;
      },
      validator: (String value) {
        return value.contains('@') ? 'Do not use the @ char.' : null;
      },
    );
  }

  Widget submitButton() {
    return RaisedButton(
      color: Colors.blue,
      child: Text('確認修改'),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print('$name,$email');
        }
      },
    );
  }
}
