import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/file_sharer.dart';

class ShareFilesParams extends Equatable {
  const ShareFilesParams(this.paths, {this.subject});

  final List<String> paths;
  final String? subject;

  @override
  List<Object?> get props => [paths, subject];
}

class ShareFiles implements UseCase<bool, ShareFilesParams> {
  const ShareFiles(this._sharer);

  final FileSharer _sharer;

  @override
  Future<bool> call(ShareFilesParams p) =>
      _sharer.share(p.paths, subject: p.subject);
}
