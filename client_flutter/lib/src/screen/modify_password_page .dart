import 'package:flutter/material.dart';
import 'modify_profile_page.dart';

class ModifyPasswordPage extends StatefulWidget {
  @override
  _ModifyPasswordPageState createState() => _ModifyPasswordPageState();
}

class _ModifyPasswordPageState extends State<ModifyPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[600],
        // title: Text('個人資訊'),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              // if (formKey.currentState.validate()) {
              // formKey.currentState.save();
              Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ModifyProfilePage(),
                ),
              );
              // }
            },
            child: Text(
              "完成",
              style: TextStyle(fontSize: 16.0),
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
