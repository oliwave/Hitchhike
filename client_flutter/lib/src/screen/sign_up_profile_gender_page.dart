import 'package:flutter/material.dart';
import 'sign_up_profile_birthday_page.dart';

class GenderPage extends StatefulWidget {
  final String title;
  final Function selectCallback;
  GenderPage({this.title, this.selectCallback});

  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey: to access form

  var pressAttention = '';
  bool isNextBtnEnable = false;
  String _gender = '';

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
      body: Container(
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 50.0, right: 50.0, left: 50.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.star_half,
                        color: Colors.teal,
                      ),
                      Text(
                        "生理性別",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 25.0),
                      genderField(user),
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
                          color:
                              isNextBtnEnable ? Colors.teal : Colors.teal[50],
                          onPressed: () {
                            if (_formKey.currentState.validate() &&
                                isNextBtnEnable) {
                              _formKey.currentState.save();
                              user['gender'] = _gender;
                              Navigator.push<String>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BirthdayPage(title: "填寫基本資訊(3/3)"),
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

  Widget genderField(Map user) {
    return Column(
      children: <Widget>[
        ButtonTheme(
          minWidth: 90.0,
          height: 75.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 水平分佈
            children: <Widget>[
              FlatButton(
                shape: CircleBorder(side: BorderSide(color: Colors.grey[400])),
                child: Text('男'),
                color: pressAttention == 'M' ? Colors.teal : Colors.white,
                onPressed: () {
                  setState(() {
                    _gender = 'Male';
                    pressAttention = 'M';
                    isNextBtnEnable = true;
                  });
                  print(_gender);
                },
              ),
              FlatButton(
                shape: CircleBorder(side: BorderSide(color: Colors.grey[400])),
                child: Text('女'),
                color: pressAttention == 'F' ? Colors.teal : Colors.white,
                onPressed: () {
                  setState(() {
                    _gender = 'Female';
                    pressAttention = 'F';
                    isNextBtnEnable = true;
                  });
                  print(_gender);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
