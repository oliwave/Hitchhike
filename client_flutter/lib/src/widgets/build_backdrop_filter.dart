import 'dart:ui';

import 'package:flutter/material.dart';

Widget buildBackdropFilter(BuildContext context, {Widget widget}) {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
    child: widget ?? Container(color: Colors.black.withOpacity(0.0)),
  );
}
