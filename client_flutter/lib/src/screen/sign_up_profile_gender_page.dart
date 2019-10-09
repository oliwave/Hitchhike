import 'package:flutter/material.dart';
import 'sign_up_profile_birthday_page.dart';

class GenderPage extends StatefulWidget {
  final String title;
  final Function selectCallback;
  GenderPage({this.title, this.selectCallback});

  @override
  State<StatefulWidget> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey: to access form
  var pressAttention = '';
  @override
  Widget build(BuildContext context) {
    Map user = Map.of(ModalRoute.of(context).settings.arguments);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
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
                      Text("Select your gender."),
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
                              disabledTextColor: Colors.teal[50],
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
                                            BirthdayPage(title: "Sign Up"),
                                        settings: RouteSettings(
                                          arguments: user,
                                        ),
                                      ));
                                }
                              },
                              child: Text("Next"))),
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
                child: Text('Male'),
                color: pressAttention == 'M' ? Colors.teal : Colors.white,
                onPressed: () {
                  user['gender'] = 'Male';
                  setState(() => pressAttention = 'M');
                  print(user['gender']);
                },
              ),
              FlatButton(
                shape: CircleBorder(side: BorderSide(color: Colors.grey[400])),
                child: Text('Female'),
                color: pressAttention == 'F' ? Colors.teal : Colors.white,
                onPressed: () {
                  user['gender'] = 'Female';
                  setState(() => pressAttention = 'F');
                  print(user['gender']);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
