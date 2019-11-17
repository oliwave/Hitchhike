// get jwt
import 'dart:typed_data';

import 'package:client_flutter/src/screen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_collection.dart';
import 'modify_profile_page.dart';
import 'modify_password_page .dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile_page';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>(); // GlobalKey: to access form

  Map userProfile = <String, dynamic>{};
  Uint8List photo;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    photo = profileProvider.getPhoto();

    userProfile['name'] = profileProvider.getName();
    userProfile['gender'] = profileProvider.getGender();
    userProfile['birthday'] = profileProvider.getBirthday();
    userProfile['email'] = profileProvider.getEmail() + '@mail1.ncnu.edu.tw';
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
          padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
          child: ListView(
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 150.0,
                      height: 155.0,
                      child: photo == null ? defaultImage() : ovalImage(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Theme(
                      child: Column(
                        children: ListTile.divideTiles(
                          context: context,
                          tiles: [
                            nameField(),
                            genderField(),
                            birthdayField(),
                            departmentField(),
                            emailField(),
                            carNumField(),
                            Divider(
                              height: 10.0,
                              indent: 0.0,
                              color: Colors.grey,
                            ),
                            editPwdField(),
                          ],
                        ).toList(),
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

// 預設圖片
  Widget defaultImage() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Image.asset(
            "assets/icons/profile/icon_head_default.png",
            fit: BoxFit.contain,
            height: 150.0,
            width: 155.0,
          ),
        ),
      ],
    );
  }

  Widget ovalImage() {
    return Stack(
      children: <Widget>[
        Align(
          child: Stack(
            children: <Widget>[
              Container(
                // 使圖對齊邊框
                padding: EdgeInsets.fromLTRB(9.0, 10.5, 0.0, 0.0),
                child: ClipOval(
                  child: Image.memory(
                    photo,
                    fit: BoxFit.cover,
                    height: 150.0,
                    width: 155.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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

  Widget editPwdField() {
    return ListTile(
      title: Text('修改密碼'),
      subtitle: TextFormField(
        enabled: false,
        decoration: InputDecoration(),
      ),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ModifyPasswordPage(),
            ));
      },
    );
  }
}
