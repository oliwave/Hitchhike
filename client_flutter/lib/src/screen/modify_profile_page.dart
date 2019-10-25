// get jwt
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../provider/provider_collection.dart'
    show AuthProvider, ProfileProvider;
import '../util/image_handler.dart';
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
  TextEditingController birthdayController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController carNumController = TextEditingController();

  String _date = '';

  @override
  void initState() {
    super.initState();
    nameController.addListener(() => setState(() {}));
    birthdayController.addListener(() => setState(() {}));
    departmentController.addListener(() => setState(() {}));
    emailController.addListener(() => setState(() {}));
    carNumController.addListener(() => setState(() {}));
    var permission =
        PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    print("permission status is " + permission.toString());
    PermissionHandler().requestPermissions(<PermissionGroup>[
      PermissionGroup.storage, // 在這裏添加需要的權限
    ]);
  }

  String newname = '';
  String birthday = '';
  String department = '';
  // String _photo = '';
  String carNum = '';

  File _image;
  Future getCameraImage() async {
    var image = await ImageHandler.getCameraImage();
    print(image);
    setState(() {
      _image = image;
    });
  }

  Future getGalleryImage() async {
    var image = await ImageHandler.getGalleryImage();
    print(image);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final authProivder = Provider.of<AuthProvider>(context, listen: false);
    final jwtToken = authProivder.jwt;

    Map userProfile = Map.of(ModalRoute.of(context).settings.arguments);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[600],
        centerTitle: true,
        title: Text('編輯個人資訊'),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () async {
              if (formKey.currentState.validate()) {
                formKey.currentState.save();
                if (newname.length > 0) {
                  await profileProvider.invokeModifyName(newname, jwtToken);
                }
                profileProvider.invokeModifyPhoto(_image, jwtToken);
                if (birthday.length > 0) {
                  await profileProvider.invokeModifyBirthday(
                      birthday, jwtToken);
                }
                if (department.length > 0) {
                  await profileProvider.invokeModifyDepartment(
                      department, jwtToken);
                }
                await profileProvider.invokeModifyPhoto(_image, jwtToken);
                await ImageHandler.testSaveImg(_image);
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
                          onTap: getCameraImage,
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
                          nameField(userProfile),
                          genderField(userProfile),
                          birthdayField(userProfile),
                          departmentField(userProfile),
                          emailField(userProfile),
                          carNumField(userProfile),
                        ],
                      ),
                      data: Theme.of(context).copyWith(
                        primaryColor: Colors.teal[600],
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
          alignment: Alignment.topLeft,
          child: Image.asset(
            "assets/icons/profile/icon_head_default.png",
            fit: BoxFit.contain,
            height: 150.0,
            width: 155.0,
          ),
        ),
        Align(
          // 編輯圖示放在右下方
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            tooltip: 'Pick Image',
            backgroundColor: Colors.teal[600],
            child: Icon(Icons.add_a_photo),
            onPressed: getCameraImage,
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
            ],
          ),
        ),
        Align(
          // 編輯圖示放在右下方
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            tooltip: 'Pick Image',
            backgroundColor: Colors.teal[600],
            child: Icon(Icons.add_a_photo),
            onPressed: getCameraImage,
          ),
        ),
      ],
    );
  }

  Widget nameField(Map userProfile) {
    return ListTile(
      title: Text('姓名'),
      subtitle: TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          hintText: userProfile['name'],
          suffixIcon: GestureDetector(
            onTap: () {
              nameController.clear();
            },
            child: Icon(nameController.text.length > 0 ? Icons.clear : null),
          ),
        ),
        onSaved: (String value) {
          newname = value;
        },
      ),
    );
  }

  Widget genderField(Map userProfile) {
    return ListTile(
      title: Text('性別'),
      subtitle: TextFormField(
        enabled: false,
        decoration: InputDecoration(
          hintText: userProfile['gender'],
        ),
      ),
      // Theme(
      //   data: Theme.of(context).copyWith(
      //     canvasColor: Colors.white,
      //   ),
      //   child: DropdownButton<String>(
      //     value: userProfile['gender'],
      //     icon: Icon(Icons.arrow_drop_down),
      //     iconSize: 24,
      //     elevation: 16,
      //     style: TextStyle(color: Colors.black),
      //     underline: Container(
      //       height: 1.0,
      //       color: Colors.grey,
      //     ),
      //     onChanged: (String newValue) {
      //       setState(() {
      //         userProfile['gender'] = newValue;
      //       });
      //     },
      // items:
      //     <String>['男', '女'].map<DropdownMenuItem<String>>((String value) {
      //   return DropdownMenuItem<String>(
      //     value: value,
      //     child: Text(value),
      //   );
      // }).toList(),
      //   ),
      // ),
    );
  }

  Widget birthdayField(Map userProfile) {
    var textFormField = TextFormField(
      controller: birthdayController,
      keyboardType: TextInputType.datetime, // 鍵盤樣式
      decoration: InputDecoration(
        hintText: userProfile['birthday'],
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

  Widget departmentField(Map userProfile) {
    return ListTile(
      title: Text('學系'),
      subtitle: TextFormField(
        controller: departmentController,
        decoration: InputDecoration(
          hintText: userProfile['department'],
          suffixIcon: GestureDetector(
            onTap: () {
              departmentController.clear();
            },
            child:
                Icon(departmentController.text.length > 0 ? Icons.clear : null),
          ),
        ),
        onSaved: (String value) {
          department = value;
        },
      ),
    );
  }

  Widget carNumField(Map userProfile) {
    return ListTile(
      title: Text('登記車輛'),
      subtitle: TextFormField(
        controller: carNumController,
        enabled: false,
        decoration: InputDecoration(
          hintText: userProfile['carNum'],
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
              settings: RouteSettings(arguments: userProfile['carNum']),
            ));
      },
    );
  }

  Widget emailField(Map userProfile) {
    return ListTile(
      title: Text('E-mail'),
      subtitle: TextFormField(
        controller: emailController,
        enabled: false,
        keyboardType: TextInputType.emailAddress, // 鍵盤樣式
        decoration: InputDecoration(
          hintText: userProfile['email'],
          suffixIcon: GestureDetector(
            onTap: () {
              emailController.clear();
            },
            child: Icon(emailController.text.length > 0 ? Icons.clear : null),
          ),
        ),
        onSaved: (String value) {
          userProfile['email'] = value;
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
