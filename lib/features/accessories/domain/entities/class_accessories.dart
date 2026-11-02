import 'package:equatable/equatable.dart';

import 'accessory_item.dart';
import 'accessory_kind.dart';
import 'student_accessory_row.dart';

/// A class's dress (or books): what is in the set, and where each student
/// stands.
class ClassAccessories extends Equatable {
  const ClassAccessories({
    required this.className,
    required this.kind,
    required this.items,
    required this.rows,
  });

  final String className;
  final AccessoryKind kind;
  final List<AccessoryItem> items;
  final List<StudentAccessoryRow> rows;

  int get completeCount => rows.where((r) => r.isComplete).length;
  int get incompleteCount => rows.length - completeCount;

  /// How many students are noted for each size, for ordering. Students with
  /// no size are counted apart.
  Map<String, int> get sizeCounts {
    final counts = <String, int>{};
    for (final r in rows) {
      if (r.hasSize) counts[r.size!.trim()] = (counts[r.size!.trim()] ?? 0) + 1;
    }
    return Map.fromEntries(
      counts.entries.toList()..sort((a, b) => _bySize(a.key, b.key)),
    );
  }

  /// Numbers in number order, then everything else by name.
  static int _bySize(String a, String b) {
    final x = int.tryParse(a);
    final y = int.tryParse(b);
    if (x != null && y != null) return x.compareTo(y);
    if (x != null) return -1;
    if (y != null) return 1;
    return a.compareTo(b);
  }

  int get withoutSizeCount => rows.where((r) => !r.hasSize).length;
  int get withSizeCount => rows.length - withoutSizeCount;

  @override
  List<Object?> get props => [className, kind, items, rows];
}
