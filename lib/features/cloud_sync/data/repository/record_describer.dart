import 'package:sqflite/sqflite.dart';

/// Gives a synced row a name a person can recognise: a student's name, a
/// notice's title, "Rahul · 2026-10-05" for an attendance mark. Looks the
/// student, teacher or paper up on this phone when the row only has its id.
class RecordDescriber {
  RecordDescriber._();

  static const _own = ['name', 'title', 'text', 'question', 'key', 'reason'];

  static Future<String> label(
    DatabaseExecutor db,
    String table,
    Map<String, Object?> row,
  ) async {
    final parts = <String>[];
    String? first(Iterable<String> columns) {
      for (final c in columns) {
        final v = row[c];
        if (v is String && v.trim().isNotEmpty) return v.trim();
      }
      return null;
    }

    Future<String?> lookup(String t, String column, Object? id) async {
      if (id == null) return null;
      final r = await db.query(
        t,
        columns: [column],
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return r.isEmpty ? null : r.first[column] as String?;
    }

    final own = first(_own);
    if (own != null) {
      parts.add(own);
    } else {
      final student = await lookup('students', 'name', row['student_id']);
      final teacher = await lookup('users', 'name', row['teacher_id']);
      final staff = await lookup('other_staff', 'name', row['staff_id']);
      final paper = await lookup('exam_papers', 'title', row['paper_id']);
      parts.addAll([?student, ?teacher, ?staff, ?paper]);
    }
    if (table == 'teacher_subjects') {
      final teacher = await lookup('users', 'name', row['teacher_id']);
      final subject = first(['subject']);
      final cls = first(['class_name']);
      parts
        ..clear()
        ..addAll([
          ?teacher,
          [?subject, ?cls].join(' · '),
        ]);
    }
    final day = first(['day']);
    if (day != null) parts.add(day);
    if (parts.isEmpty) {
      final id = first(['id']);
      if (id != null) parts.add(id);
    }
    return parts.where((p) => p.isNotEmpty).join(' · ');
  }
}
