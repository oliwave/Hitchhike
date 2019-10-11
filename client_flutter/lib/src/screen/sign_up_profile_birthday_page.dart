import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:client_flutter/src/provider/provider_collection.dart';
import 'page_collection.dart';

class BirthdayPage extends StatefulWidget {
  final String title;
  BirthdayPage({this.title});

  @override
  State<StatefulWidget> createState() {
    return new _BirthdayPage();
  }
}

class _BirthdayPage extends State<BirthdayPage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey: to access form

  TextEditingController controller;

  String _date = '';

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProivder = Provider.of<AuthProvider>(context, listen: false);
    Map user = Map.of(ModalRoute.of(context).settings.arguments);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ),
        title: Text(widget.title),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 點空白收起鍵盤
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 50.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 100.0),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.date_range,
                            color: Colors.teal,
                          ),
                          Text("Select Your Birthday."),
                          SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            "$_date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26.0),
                          ),
                          Divider(
                            height: 25.0,
                            indent: 0.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      child: Text('Select'),
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true,
                            minTime: DateTime(1870, 1, 1),
                            maxTime: DateTime.now(), onConfirm: (date) {
                          print('confirm $date');
                          _date = '${date.year}-${date.month}-${date.day}';
                          setState(() {});
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
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
                                  user['birthday'] = _date;
                                  print(user);
                                  authProivder.invokeSignUp(user);
                                  String targetRoute;
                                  targetRoute = LoginPage.routeName;
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    targetRoute,
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                child: Text("Finish")),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
