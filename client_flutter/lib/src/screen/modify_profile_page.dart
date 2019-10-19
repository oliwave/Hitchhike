// get jwt
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../provider/provider_collection.dart' show AuthProvider;
import 'page_collection.dart';
import 'modify_carNum_page.dart';

class ModifyProfilePage extends StatefulWidget {
  static const String routeName = '/modifyprofile_page';

  @override
  _ModifyProfilePageState createState() => _ModifyProfilePageState();
}

class _ModifyProfilePageState extends State<ModifyProfilePage> {
  final formKey = GlobalKey<FormState>(); // GlobalKey: to access form

  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController carNumController = TextEditingController();

  String name = 'test1';
  String gender = '男';
  String birthday = '2019-12-01';
  String email = 'test4@ncnu.edu.tw';
  String carNum = 'test5';
  String _date = '';
  String dropdownValue = 'One';
  @override
  void initState() {
    super.initState();
    nameController.addListener(() => setState(() {}));
    genderController.addListener(() => setState(() {}));
    birthdayController.addListener(() => setState(() {}));
    emailController.addListener(() => setState(() {}));
    carNumController.addListener(() => setState(() {}));

    final authProivder = Provider.of<AuthProvider>(context, listen: false);
    final jwtToken = authProivder.jwt;
  }

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        centerTitle: true,
        title: Text('編輯個人資訊'),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              if (formKey.currentState.validate()) {
                formKey.currentState.save();
                print('$name,$gender,$birthday,$email,$carNum');
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  ProfilePage.routeName,
                  (Route<dynamic> route) => false,
                );
              }
            },
            child: Text(
              "儲存",
              style: TextStyle(fontSize: 16.0),
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
        leading: IconButton(
          // textColor: Colors.white,
          icon: Icon(Icons.clear),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => alert(),
            );
          },
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 點空白收起鍵盤
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 50.0),
          child: ListView(
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: getImage,
                          child: Container(
                            width: 150.0,
                            height: 155.0,
                            child: _image == null
                                ? defaultImage()
                                : ovalImage(_image),
                          ),
                        ),
                      ],
                    ),
                    Theme(
                      child: Column(
                        children: <Widget>[
                          nameField(),
                          genderField(),
                          birthdayField(),
                          emailField(),
                          carNumField(),
                        ],
                      ),
                      data: Theme.of(context).copyWith(
                        primaryColor: Colors.teal[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 預設圖片
  Widget defaultImage() {
    return Stack(
      children: <Widget>[
        Align(
          // 預設圖片放在左上方
          alignment: Alignment.topLeft,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.teal[400],
              ),
            ),
          ),
          // Image.asset(
          //   'assets/icon_head_default.png',
          //   fit: BoxFit.contain,
          //   height: 150.0,
          //   width: 155.0,
          // ),
        ),
        Align(
          // 編輯圖示放在右下方
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            tooltip: 'Pick Image',
            backgroundColor: Colors.teal[400],
            child: Icon(Icons.add_a_photo),
            onPressed: getImage,
          ),
        ),
      ],
    );
  }

  Widget ovalImage(File image) {
    return Stack(
      children: <Widget>[
        Align(
          child: Stack(
            children: <Widget>[
              Container(
                // 使圖對齊邊框
                padding: EdgeInsets.fromLTRB(9.0, 10.5, 0.0, 0.0),
                child: ClipOval(
                  child: Image.file(
                    image,
                    fit: BoxFit.cover,
                    height: 150.0,
                    width: 150.0,
                  ),
                ),
              ),
              Image.asset(
                'assets/icon_head_default_null.png',
                fit: BoxFit.contain,
                height: 150.0,
                width: 155.0,
              ),
            ],
          ),
        ),
        Align(
          // 編輯圖示放在右下方
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            tooltip: 'Pick Image',
            backgroundColor: Colors.teal[400],
            child: Icon(Icons.add_a_photo),
            onPressed: getImage,
          ),
        ),
      ],
    );
  }

  Widget nameField() {
    return ListTile(
      title: Text('姓名'),
      subtitle: TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          hintText: "$name",
          suffixIcon: GestureDetector(
            onTap: () {
              nameController.clear();
            },
            child: Icon(nameController.text.length > 0 ? Icons.clear : null),
          ),
        ),
        onSaved: (String value) {
          name = value;
        },
      ),
    );
  }

  Widget genderField() {
    return ListTile(
      title: Text('性別'),
      subtitle: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: DropdownButton<String>(
          value: gender,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.black),
          underline: Container(
            height: 1.0,
            color: Colors.grey,
          ),
          onChanged: (String newValue) {
            setState(() {
              gender = newValue;
            });
          },
          items:
              <String>['男', '女'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
      // TextFormField(
      //   controller: genderController,
      //   decoration: InputDecoration(
      //     hintText: '$gender',
      //     suffixIcon: GestureDetector(
      //       onTap: () {
      //         genderController.clear();
      //       },
      //       child: Icon(genderController.text.length > 0 ? Icons.clear : null),
      //     ),
      //   ),
      //   onSaved: (String value) {
      //     gender = value;
      //   },
      // ),
    );
  }

  var _time;
  Widget birthdayField() {
    var textFormField = TextFormField(
      controller: birthdayController,
      keyboardType: TextInputType.datetime, // 鍵盤樣式
      decoration: InputDecoration(
        hintText: '$birthday',
        suffixIcon: GestureDetector(
          onTap: () {
            birthdayController.clear();
          },
          child: Icon(birthdayController.text.length > 0 ? Icons.clear : null),
        ),
      ),
      onEditingComplete: () {
        birthdayController.text = '$_date';
      },
      onSaved: (String value) {
        birthday = value;
      },
    );
    return Column(
      children: <Widget>[
        ListTile(
          title: Text('生日'),
          subtitle: textFormField,
          trailing: Icon(Icons.arrow_drop_down),
          onTap: () {
            DatePicker.showDatePicker(context,
                theme: DatePickerTheme(
                  containerHeight: 210.0,
                ),
                showTitleActions: true,
                minTime: DateTime(1870, 1, 1),
                maxTime: DateTime.now(), onConfirm: (date) {
              print('confirm $date');
              _date = '${date.year}-${date.month}-${date.day}';
              birthdayController.text = '$_date';
              setState(() {});
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
        ),
      ],
    );
  }

  Widget carNumField() {
    return ListTile(
      title: Text('登記車輛'),
      subtitle: TextFormField(
        controller: carNumController,
        enabled: false,
        decoration: InputDecoration(
          hintText: '$carNum',
          suffixIcon: GestureDetector(
            onTap: () {
              carNumController.clear();
            },
            child: Icon(carNumController.text.length > 0 ? Icons.clear : null),
          ),
        ),
        onSaved: (String value) {
          carNum = value;
        },
      ),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ModifyCarNumPage(),
              settings: RouteSettings(arguments: carNum),
            ));
      },
    );
  }

  Widget emailField() {
    return ListTile(
      title: Text('E-mail'),
      subtitle: TextFormField(
        controller: emailController,
        enabled: false,
        keyboardType: TextInputType.emailAddress, // 鍵盤樣式
        decoration: InputDecoration(
          hintText: '$email',
          suffixIcon: GestureDetector(
            onTap: () {
              emailController.clear();
            },
            child: Icon(emailController.text.length > 0 ? Icons.clear : null),
          ),
        ),
        onSaved: (String value) {
          email = value;
        },
      ),
    );
  }

  Widget alert() {
    return AlertDialog(
      title: Text("提醒"),
      content: Text("内容尚未儲存，確定要返回？"),
      actions: <Widget>[
        FlatButton(
          child: Text("取消"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("確定"),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              ProfilePage.routeName,
              (Route<dynamic> route) => false,
            );
          },
        ),
      ],
    );
  }
}
