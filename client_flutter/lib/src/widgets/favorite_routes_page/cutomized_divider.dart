import 'package:flutter/Material.dart';

class CustomizedDivider extends StatelessWidget {
  const CustomizedDivider({
    Key key,
    @required this.padding,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double padding;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(padding),
      color: Colors.grey,
      height: height,
      width: width,
    );
  }
}
