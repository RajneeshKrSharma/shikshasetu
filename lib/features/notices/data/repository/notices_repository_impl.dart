import '../../../../core/data/local/app_database.dart';
import '../../domain/entities/notice.dart';
import '../../domain/repository/notices_repository.dart';
import '../dto/notice_dto.dart';
import '../models/notice_model.dart';

class NoticesRepositoryImpl implements NoticesRepository {
  NoticesRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Future<List<Notice>> getNotices() async {
    final rows = await _database.db.query('notices', orderBy: 'posted_at DESC');
    return [for (final r in rows) NoticeModel.fromDto(NoticeDto.fromMap(r))];
  }

  @override
  Future<void> post(Notice notice) => _database.db.insert(
    'notices',
    NoticeModel.fromEntity(notice).toDto().toMap(),
  );
}
