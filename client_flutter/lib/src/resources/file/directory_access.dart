import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DirectoryAccess {
  DirectoryAccess._();

  static Directory _directory;
  static bool _isFirst;

  static Future<void> initDirectory() async {
    if (_isFirst) {
      // provide by path_provider package to get a path of folder on our mobile device
      // where we can save our data.
      _directory = await getApplicationDocumentsDirectory();
      _isFirst = !_isFirst;
    }
  }

  static String getFilePath(String fileName) {
    return join(_directory.path, fileName);
  }
}
