import 'package:image_picker/image_picker.dart';

import '../../domain/entities/scanned_question.dart';
import '../../domain/repository/photo_picker_repository.dart';

class ImagePickerPhotoRepository implements PhotoPickerRepository {
  @override
  Future<String?> pick(PhotoSource source) async {
    final photo = await ImagePicker().pickImage(
      source: switch (source) {
        PhotoSource.camera => ImageSource.camera,
        PhotoSource.gallery => ImageSource.gallery,
      },
      maxWidth: 2200,
    );
    return photo?.path;
  }
}
