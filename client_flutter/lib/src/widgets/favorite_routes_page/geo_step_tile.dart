import 'package:flutter/material.dart';

class GeoStepTile extends StatelessWidget {
  GeoStepTile({
    @required this.title,
    @required this.subtitle,
    this.isStart,
  });

  final String title;
  final String subtitle;
  final bool isStart;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: isStart != null
          ? Icon(
              isStart ? Icons.looks_one : Icons.looks_two,
              color: Colors.blue,
              size: 25,
            )
          : null,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          textAlign: isStart != null ? null : TextAlign.center,
        ),
      ),
      subtitle: Text(
        subtitle,
        textAlign:  isStart != null ? null : TextAlign.center,
      ),
    );
  }
}
