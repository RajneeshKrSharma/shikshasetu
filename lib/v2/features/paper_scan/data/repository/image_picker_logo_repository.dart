import 'package:image_picker/image_picker.dart';

import '../../domain/repository/logo_picker_repository.dart';

class ImagePickerLogoRepository implements LogoPickerRepository {
  @override
  Future<String?> pick() async {
    final photo = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
    );
    return photo?.path;
  }
}
