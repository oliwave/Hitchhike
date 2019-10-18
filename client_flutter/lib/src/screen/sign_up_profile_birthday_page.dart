import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client_flutter/src/provider/provider_collection.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'page_collection.dart';

class BirthdayPage extends StatefulWidget {
  final String title;
  BirthdayPage({this.title});

  @override
  _BirthdayPage createState() => _BirthdayPage();
}

class _BirthdayPage extends State<BirthdayPage> {
  TextEditingController controller = TextEditingController();

  String _date = '';
  bool isNextBtnEnable = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
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
          if (controller.text.length > 0) {
            isNextBtnEnable = true;
          }
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 50.0),
          child: Form(
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
                            color: Colors.teal[600],
                          ),
                          Text(
                            "你的生日",
                            style: TextStyle(fontSize: 18.0),
                          ),
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
                      child: Text('選擇日期'),
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
                          setState(() {
                            isNextBtnEnable = true;
                          });
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
                              color: isNextBtnEnable
                                  ? Colors.teal[600]
                                  : Colors.teal[50],
                              onPressed: () {
                                user['birthday'] = _date;
                                print(user);
                                authProivder.invokeSignUp(user);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  Homepage.routeName,
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: Text(
                                isNextBtnEnable ? '完成' : '略過(完成)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
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
