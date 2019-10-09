import 'package:flutter/material.dart';

import 'package:bubble/bubble.dart';
import '../../util/util_collection.dart' show SizeConfig;

class ChatBubbleStyle {
  ChatBubbleStyle._();

  static BubbleStyle somebody = BubbleStyle(
    nip: BubbleNip.leftTop,
    color: Colors.white,
    // elevation: 1 * px,
    elevation: 1,
    margin: BubbleEdges.only(
      top: SizeConfig.screenAwareHeight(1.0),
      right: SizeConfig.screenAwareHeight(25.0),
    ),
    alignment: Alignment.topLeft,
  );

  static BubbleStyle me = BubbleStyle(
    nip: BubbleNip.rightTop,
    color: Color.fromARGB(255, 225, 255, 199),
    // elevation: 1 * px,
    elevation: 1,
    margin: BubbleEdges.only(
      top: SizeConfig.screenAwareHeight(1.0),
      left: SizeConfig.screenAwareHeight(25.0),
    ),
    alignment: Alignment.topRight,
  );
}
