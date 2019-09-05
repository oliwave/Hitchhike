import 'dart:convert';

import 'dart:io';

import 'package:flutter/Material.dart';

import '../../resources/file/directory_access.dart';

class JsonFileHandler {
  JsonFileHandler._();

  factory JsonFileHandler() {
    return _jsonFileHandler;
  }

  static final _jsonFileHandler = JsonFileHandler._();

  /// Call this method will override the original file content with new
  /// data.
  Future<void> writeToFile({
    @required String fileName,
    @required Map<String, dynamic> data,
  }) async {
    print("Writing to file!");

    File jsonFile = File(DirectoryAccess.getFilePath(fileName));

    if (!_checkFileExisted(jsonFile)) {
      print("File does not exist!");
      // _createFile( fileName: jsonFile);
      jsonFile = await jsonFile.create();
    }

    print("File exists");

    // Write the modified map object to json file.
    // (By default, it will override the file content)
    await jsonFile.writeAsString(json.encode(data));
  }

  /// Read the content of specified json file.
  ///
  /// Return `null` if the file doesn't exist.
  Future<Map<String, dynamic>> readFile({
    @required String fileName,
  }) async {
    final jsonFile = File(DirectoryAccess.getFilePath(fileName));

    if (!_checkFileExisted(jsonFile)) return null;
    
    return json.decode(await jsonFile.readAsString());
  }

  bool _checkFileExisted(File file) => file.existsSync();
}
