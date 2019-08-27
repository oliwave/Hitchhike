import 'package:flutter/Material.dart';

class BriefText extends StatelessWidget {
  const BriefText({
    Key key,
    @required this.text,
    @required this.isExpanded,
  }) : super(key: key);

  final String text;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final content = Text(
      text,
      overflow: TextOverflow.clip,
      maxLines: 2,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.grey[700],
        fontWeight: isExpanded ? FontWeight.normal : FontWeight.bold,
        fontSize: isExpanded ? 10 : 16,
        letterSpacing: 2,
      ),
    );
    return isExpanded ? Expanded(child: content) : content;
  }
}
