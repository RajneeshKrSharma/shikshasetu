import '../../domain/entities/backup_entities.dart';
import '../dto/backup_dto.dart';

class BackupPreviewModel extends BackupPreview {
  const BackupPreviewModel({
    required super.createdAt,
    required super.counts,
    super.writtenBy,
  });

  factory BackupPreviewModel.fromDto(BackupDto d) => BackupPreviewModel(
    createdAt: DateTime.parse(d.createdAt),
    writtenBy: d.writtenBy,
    counts: {for (final e in d.tables.entries) e.key: e.value.length},
  );
}
