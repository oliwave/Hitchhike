import 'package:flutter/material.dart';
import 'modify_profile_page.dart';

class ModifyCarNumPage extends StatefulWidget {
  @override
  _ModifyCarNumPageState createState() => _ModifyCarNumPageState();
}

class _ModifyCarNumPageState extends State<ModifyCarNumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
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
