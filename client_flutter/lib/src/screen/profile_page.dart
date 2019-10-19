// get jwt
import 'package:client_flutter/src/screen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_collection.dart';
import 'modify_profile_page.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile_page';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>(); // GlobalKey: to access form

  Map userProfile = {
    'uid': 'tes1',
    'password': 'aa',
    'name': '',
    'gender': '女',
    'birthday': '1911-01-01',
    'department': '資管系',
    'carNum': 'aa123',
    'email': 'test4@ncnu.edu.tw'
  };

  @override
  void initState() {
    super.initState();
    final authProivder = Provider.of<AuthProvider>(context, listen: false);
    final jwtToken = authProivder.jwt;
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context);
    userProfile['name'] = profileProvider.getName();
    // userProfile['gender'] = profileProvider.getGender();
    userProfile['department'] = profileProvider.getDepartment();
    userProfile['carNum'] = profileProvider.getCarNum();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[600],
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
                    settings: RouteSettings(
                      arguments: userProfile,
                    )),
              );
            },
            child: Text(
              "編輯",
              style: TextStyle(fontSize: 16.0),
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Homepage.routeName,
              (Route<dynamic> route) => false,
            );
          },
        ),
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
                        // color: Colors.teal[600],
                        border: Border.all(
                          color: Colors.teal[600],
                        ),
                        image: DecorationImage(
                          image: AssetImage(
                            '',
                            // 'https://github.com/flutter/assets-for-api-docs/tree/master/assets/widgets/owl.jpg',
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
                        primaryColor: Colors.teal[600],
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
      subtitle: Text(userProfile['name']),
    );
  }

  Widget genderField() {
    return ListTile(
      title: Text('性別'),
      subtitle: Text(userProfile['gender']),
    );
  }

  Widget birthdayField() {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text('生日'),
          subtitle: Text(userProfile['birthday']),
        ),
      ],
    );
  }

  Widget departmentField() {
    return ListTile(
      title: Text('學系'),
      subtitle: Text(userProfile['department']),
    );
  }

  Widget carNumField() {
    return ListTile(
      title: Text('登記車輛'),
      subtitle: Text(userProfile['carNum']),
    );
  }

  Widget emailField() {
    return ListTile(
      title: Text('E-mail'),
      subtitle: Text(userProfile['email']),
    );
  }
}
