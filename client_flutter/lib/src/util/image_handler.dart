import 'dart:io';

import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImageHandler {
  const ImageHandler._();

  factory ImageHandler() {
    return _imageHandler;
  }

  static final _imageHandler = ImageHandler._();

  // 儲存照片到相片庫
  static Future<void> testSaveImg(File _image) async {
    final result =
        await ImageGallerySaver.saveImage(await _image.readAsBytes());
    if (result != null) {
      print('儲存成功');
    } else {
      print('儲存失敗');
    }
  }
}
