import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/repository/selfie_repository.dart';

/// Takes a selfie with the system camera and keeps it in app storage.
class SelfieRepositoryImpl implements SelfieRepository {
  @override
  Future<String?> capture(String teacherId) async {
    final shot = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      maxWidth: 1024,
    );
    if (shot == null) return null;

    final dir = Directory(
      p.join((await getApplicationDocumentsDirectory()).path, 'selfies'),
    );
    await dir.create(recursive: true);
    final target = p.join(
      dir.path,
      '${teacherId}_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await File(shot.path).copy(target);
    return target;
  }
}
