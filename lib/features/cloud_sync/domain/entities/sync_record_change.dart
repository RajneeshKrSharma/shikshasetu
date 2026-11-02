import 'package:equatable/equatable.dart';

enum RecordChangeKind { added, changed, removed }

/// One field of a record: what it was and what it is now. Null is "no value".
class FieldChange extends Equatable {
  const FieldChange(this.field, this.before, this.after);

  final String field;
  final String? before;
  final String? after;

  @override
  List<Object?> get props => [field, before, after];
}

/// One record that was sent or received: which it is, whether it is new,
/// changed or removed, and, field by field, what it was and what it is now.
class SyncRecordChange extends Equatable {
  const SyncRecordChange({
    required this.table,
    required this.key,
    required this.label,
    required this.kind,
    this.fields = const [],
    this.beforeKnown = true,
  });

  /// What changed between [before] and [after] (either may be null: a new or
  /// a removed record). [beforeKnown] is false for a changed record whose
  /// earlier value was not kept, so only the new values are listed.
  factory SyncRecordChange.diff({
    required String table,
    required String key,
    required String label,
    Map<String, Object?>? before,
    Map<String, Object?>? after,
    bool beforeKnown = true,
  }) {
    final kind = after == null
        ? RecordChangeKind.removed
        : before == null && beforeKnown
        ? RecordChangeKind.added
        : RecordChangeKind.changed;
    final names = {
      ...?before?.keys,
      ...?after?.keys,
    }.where((f) => !_private.contains(f)).toList();
    final fields = <FieldChange>[];
    for (final f in names) {
      final b = _text(before?[f]);
      final a = _text(after?[f]);
      if (kind == RecordChangeKind.changed && beforeKnown && a == b) continue;
      if (a == null && b == null) continue;
      fields.add(
        FieldChange(f, before == null ? null : b, after == null ? null : a),
      );
    }
    return SyncRecordChange(
      table: table,
      key: key,
      label: label,
      kind: kind,
      fields: fields,
      beforeKnown: beforeKnown,
    );
  }

  /// Never shown: password material.
  static const _private = {'password_hash', 'password_salt'};

  static String? _text(Object? v) => v == null ? null : '$v';

  final String table;
  final String key;

  /// A name a person can recognise (a student's name, a notice's title...).
  final String label;
  final RecordChangeKind kind;
  final List<FieldChange> fields;
  final bool beforeKnown;

  @override
  List<Object?> get props => [table, key, label, kind, fields, beforeKnown];
}
