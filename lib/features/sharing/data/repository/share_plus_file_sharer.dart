import 'package:share_plus/share_plus.dart';

import '../../domain/repository/file_sharer.dart';

class SharePlusFileSharer implements FileSharer {
  @override
  Future<bool> share(List<String> paths, {String? subject}) async {
    final result = await SharePlus.instance.share(
      ShareParams(subject: subject, files: [for (final p in paths) XFile(p)]),
    );
    return result.status == ShareResultStatus.success;
  }
}
