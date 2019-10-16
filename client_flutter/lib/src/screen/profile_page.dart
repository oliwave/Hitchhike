// get jwt
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_collection.dart' show AuthProvider;
import 'modify_profile_page.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile_page';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>(); // GlobalKey: to access form

  String name = 'test1';
  String gender = '男';
  String birthday = '2019-12-01';
  String email = 'test4@ncnu.edu.tw';
  String carNum = 'test5';

  @override
  void initState() {
    super.initState();
    final authProivder = Provider.of<AuthProvider>(context, listen: false);
    final jwtToken = authProivder.jwt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        centerTitle: true,
        title: Text('個人資訊'),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ModifyProfilePage(),
                ),
              );
            },
            child: Text(
              "編輯",
              style: TextStyle(fontSize: 16.0),
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 50.0),
          child: ListView(
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // color: Colors.teal[400],
                        border: Border.all(
                          color: Colors.teal[400],
                        ),
                        image: DecorationImage(
                          image: AssetImage(
                            'https://github.com/flutter/assets-for-api-docs/tree/master/assets/widgets/owl.jpg',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Theme(
                      child: Column(
                        children:
                            ListTile.divideTiles(context: context, tiles: [
                          nameField(),
                          genderField(),
                          birthdayField(),
                          departmentField(),
                          emailField(),
                          carNumField(),
                        ]).toList(),
                      ),
                      data: Theme.of(context).copyWith(
                        primaryColor: Colors.teal[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget nameField() {
    return ListTile(
      title: Text('姓名'),
      subtitle: Text('$name'),
    );
  }

  Widget genderField() {
    return ListTile(
      title: Text('性別'),
      subtitle: Text('$gender'),
    );
  }

  Widget birthdayField() {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text('生日'),
          subtitle: Text('$birthday'),
        ),
      ],
    );
  }

Widget departmentField() {
    return ListTile(
      title: Text('姓名'),
      subtitle: Text('$name'),
    );
  }
  Widget carNumField() {
    return ListTile(
      title: Text('登記車輛'),
      subtitle: Text('$carNum'),
    );
  }

  Widget emailField() {
    return ListTile(
      title: Text('E-mail'),
      subtitle: Text('$email'),
    );
  }
}
