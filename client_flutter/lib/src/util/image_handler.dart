import 'package:image_picker/image_picker.dart';

class ImageHandler {
  const ImageHandler._();

  factory ImageHandler() {
    return _imageHandler;
  }

  static final _imageHandler = ImageHandler._();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    return image;
  }
}
