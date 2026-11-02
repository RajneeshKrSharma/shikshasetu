import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repository/external_copy_repository.dart';

class PublishMirrorParams extends Equatable {
  const PublishMirrorParams(this.path, this.at);

  final String path;
  final DateTime at;

  @override
  List<Object?> get props => [path, at];
}

/// Copies the data file outside the app, as the one file that is always the
/// latest (it replaces the one before, so copies do not pile up).
class PublishMirrorCopy implements UseCase<void, PublishMirrorParams> {
  const PublishMirrorCopy(this._copies);

  final ExternalCopyRepository _copies;

  /// The name of the copy outside the app.
  static const fileName = 'shiksha_setu_latest.json';

  @override
  Future<void> call(PublishMirrorParams p) => _copies.save(p.path, fileName);
}
