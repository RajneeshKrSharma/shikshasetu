import 'package:flutter/services.dart';

import '../../domain/repository/external_copy_repository.dart';

/// Writes into Download/ShikshaSetu through the phone's media store (Android
/// 10 and later), which needs no permission and keeps the file when the app
/// is removed.
class DownloadsExternalCopy implements ExternalCopyRepository {
  DownloadsExternalCopy({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('shiksha_setu/external_copy');

  final MethodChannel _channel;

  @override
  Future<void> save(String sourcePath, String name) async {
    await _channel.invokeMethod<String>('save', {
      'path': sourcePath,
      'name': name,
    });
  }
}
