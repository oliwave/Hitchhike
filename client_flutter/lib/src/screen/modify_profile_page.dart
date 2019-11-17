// get jwt
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../provider/provider_collection.dart'
    show AuthProvider, ProfileProvider;
import 'page_collection.dart';
import '../util/image_handler.dart';
import 'modify_carNum_page.dart';
import '../widgets/profile_page/store_cancel_view.dart';

class ModifyProfilePage extends StatefulWidget {
  static const String routeName = '/modifyprofile_page';

  @override
  _ModifyProfilePageState createState() => _ModifyProfilePageState();
}

class _ModifyProfilePageState extends State<ModifyProfilePage> {
  final formKey = GlobalKey<FormState>(); // GlobalKey: to access form

  TextEditingController nameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();

  String _date = '';

  @override
  void initState() {
    super.initState();
    nameController.addListener(() => setState(() {}));
    birthdayController.addListener(() => setState(() {}));
    var permission =
        PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    print("permission status is " + permission.toString());
    PermissionHandler().requestPermissions(<PermissionGroup>[
      PermissionGroup.storage, // 在這裡添加需要的權限
    ]);
  }

  Uint8List photo;
  String newname = '';
  String birthday = '';
  String department;
  String newDepart = '';
  String carNum = '';

  File image; // ImagePicker取得的相片
  File _image; // 要設成大頭照的相片
  getCameraImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  getGalleryImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void removePhoto() {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final jwtToken = authProvider.jwt;
    profileProvider.invokeModifyPhoto(null, jwtToken);
  }

  void _getImage() {
    setState(() {
      showGetImageActionSheet(
        context: context,
        child: CupertinoActionSheet(
          title: const Text(
            '更換大頭貼照',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text('相機'),
              onPressed: () {
                getCameraImage();
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('從相簿中選取'),
              onPressed: () {
                getGalleryImage();
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: const Text('移除大頭貼照'),
              onPressed: () {
                setState(() {
                  photo = null;
                  removePhoto();
                });
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('取消'),
            isDefaultAction: true, // 粗體
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    });
  }

  void showGetImageActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value != null) {
        setState(() {});
      }
    });
  }

  void _onCancelButtonClick() {
    showDemoDialog(
      context: context,
      child: const CupertinoDessertDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    photo = profileProvider.getPhoto();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final jwtToken = authProvider.jwt;

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
                if (newname.length > 0 && newname != userProfile['name']) {
                  await profileProvider.invokeModifyName(newname, jwtToken);
                }
                if (birthday.length > 0 &&
                    birthday != userProfile['birthday']) {
                  await profileProvider.invokeModifyBirthday(
                      birthday, jwtToken);
                }
                if (newDepart.length > 0 &&
                    newDepart != userProfile['department']) {
                  await profileProvider.invokeModifyDepartment(
                      newDepart, jwtToken);
                }
                if (_image != null) {
                  await profileProvider.invokeModifyPhoto(_image, jwtToken);
                  await ImageHandler.testSaveImg(_image);
                }
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
            _onCancelButtonClick();
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
          padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
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
                          onTap: _getImage,
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
                    Column(
                      children: <Widget>[
                        nameField(userProfile),
                        genderField(userProfile),
                        birthdayField(userProfile),
                        departmentField(userProfile),
                        emailField(userProfile),
                        carNumField(userProfile),
                      ],
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
          child: ClipOval(
            child: photo == null
                ? Image.asset(
                    "assets/icons/profile/icon_head_default.png",
                    fit: BoxFit.contain,
                    height: 150.0,
                    width: 155.0,
                  )
                : Image.memory(
                    photo,
                    fit: BoxFit.cover,
                    height: 150.0,
                    width: 155.0,
                  ),
          ),
        ),
        Align(
          // 編輯圖示放在右下方
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            tooltip: 'Pick Image',
            backgroundColor: Colors.teal,
            child: Icon(Icons.edit),
            onPressed: _getImage,
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
            backgroundColor: Colors.teal,
            child: Icon(Icons.edit),
            onPressed: _getImage,
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
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])),
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
    );
  }

  Widget birthdayField(Map userProfile) {
    var textFormField = TextFormField(
      controller: birthdayController,
      enabled: false,
      decoration: InputDecoration(
        hintText: userProfile['birthday'],
        suffixIcon: Icon(Icons.arrow_drop_down),
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
      subtitle: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: DropdownButton<String>(
          hint: Text(userProfile['department']),
          value: department,
          icon: Icon(Icons.arrow_drop_down),
          iconEnabledColor: Colors.grey,
          style: TextStyle(color: Colors.black),
          underline: Container(
            height: 1.0,
            color: Colors.grey[400],
          ),
          onChanged: (String newValue) {
            setState(() {
              department = newValue;
              newDepart = newValue;
            });
          },
          items: <String>[
            '中文系',
            '外文系',
            '社工系',
            '公行系',
            '歷史系',
            '東南亞系',
            '原專班',
            '國企系',
            '經濟系',
            '資管系',
            '財金系',
            '觀餐系',
            '土木系',
            '資工系',
            '電機系',
            '應化系',
            '應光系',
            '國比系',
            '教政系',
            '諮人系',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget carNumField(Map userProfile) {
    return ListTile(
      title: Text('登記車輛'),
      subtitle: TextFormField(
        enabled: false,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400])),
          hintText: userProfile['carNum'],
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
        enabled: false,
        keyboardType: TextInputType.emailAddress, // 鍵盤樣式
        decoration: InputDecoration(
          hintText: userProfile['email'],
        ),
      ),
    );
  }
}
