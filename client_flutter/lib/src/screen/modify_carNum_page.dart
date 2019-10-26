import 'package:flutter/material.dart';
import 'package:client_flutter/src/provider/provider_collection.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'profile_page.dart';

class ModifyCarNumPage extends StatefulWidget {
  @override
  _ModifyCarNumPageState createState() => _ModifyCarNumPageState();
}

class _ModifyCarNumPageState extends State<ModifyCarNumPage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey: to access form

  TextEditingController newCarController = TextEditingController();

  String newCar;

  @override
  void initState() {
    super.initState();
    newCarController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final oldCar = profileProvider.getCarNum();
    final authProvider = Provider.of<AuthProvider>(context);
    final jwtToken = authProvider.jwt;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[600],
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                if (newCar.length > 0) {
                  await profileProvider.invokeModifyCarNum(newCar, jwtToken);
                }
                Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProfilePage(),
                  ),
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
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 點空白收起鍵盤
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Center(
              child: Theme(
                child: Container(
                  padding: EdgeInsets.only(top: 40.0, right: 30.0, left: 30.0),
                  child: Column(
                    children: <Widget>[
                      oldCarField(oldCar),
                      SizedBox(height: 25.0),
                      newCarField(),
                    ],
                  ),
                ),
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.teal[600],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget oldCarField(String oldCar) {
    return ListTile(
      title: Text('目前登記車牌'),
      subtitle: TextFormField(
        enabled: false,
        decoration: InputDecoration(
          labelText: oldCar,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal[600],
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget newCarField() {
    return ListTile(
      subtitle: TextFormField(
        controller: newCarController,
        autofocus: true,
        decoration: InputDecoration(
          labelText: '新車牌號碼',
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal[600],
              width: 2.0,
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              newCarController.clear();
            },
            child: Icon(newCarController.text.length > 0 ? Icons.clear : null),
          ),
        ),
        validator: (String value) => value.contains('-') ? null : '車牌號碼不正確',
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter(RegExp("[a-zA-Z]|[0-9]|[\-]")),
          LengthLimitingTextInputFormatter(10), //限制長度
        ],
        onSaved: (String value) {
          newCar = newCarController.text;
        },
      ),
    );
  }
}
