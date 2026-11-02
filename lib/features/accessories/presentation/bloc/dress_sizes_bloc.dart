import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/accessory_kind.dart';
import '../../domain/entities/class_accessories.dart';
import '../../domain/usecases/accessories_usecases.dart';

sealed class DressSizesEvent extends Equatable {
  const DressSizesEvent();

  @override
  List<Object?> get props => const [];
}

final class DressSizesStarted extends DressSizesEvent {
  const DressSizesStarted();
}

final class DressSizeChanged extends DressSizesEvent {
  const DressSizeChanged(this.studentId, this.size);

  final String studentId;
  final String size;

  @override
  List<Object?> get props => [studentId, size];
}

final class DressSizesSaveRequested extends DressSizesEvent {
  const DressSizesSaveRequested();
}

class DressSizesState extends Equatable {
  const DressSizesState({
    this.loading = true,
    this.view,
    this.sizes = const {},
    this.saving = false,
    this.saved = false,
  });

  final bool loading;
  final ClassAccessories? view;

  /// The size typed for each student, by id (empty for none).
  final Map<String, String> sizes;
  final bool saving;
  final bool saved;

  int get notedCount => sizes.values.where((s) => s.trim().isNotEmpty).length;

  /// How many students have each size, for ordering, from what is typed now.
  Map<String, int> get counts {
    final out = <String, int>{};
    for (final s in sizes.values) {
      final t = s.trim();
      if (t.isNotEmpty) out[t] = (out[t] ?? 0) + 1;
    }
    return Map.fromEntries(
      out.entries.toList()..sort((a, b) => _bySize(a.key, b.key)),
    );
  }

  static int _bySize(String a, String b) {
    final x = int.tryParse(a);
    final y = int.tryParse(b);
    if (x != null && y != null) return x.compareTo(y);
    if (x != null) return -1;
    if (y != null) return 1;
    return a.compareTo(b);
  }

  DressSizesState copyWith({
    bool? loading,
    ClassAccessories? view,
    Map<String, String>? sizes,
    bool? saving,
    bool? saved,
  }) => DressSizesState(
    loading: loading ?? this.loading,
    view: view ?? this.view,
    sizes: sizes ?? this.sizes,
    saving: saving ?? this.saving,
    saved: saved ?? this.saved,
  );

  @override
  List<Object?> get props => [loading, view, sizes, saving, saved];
}

/// Noting each student's dress size, one class at a time.
class DressSizesBloc extends Bloc<DressSizesEvent, DressSizesState> {
  DressSizesBloc({
    required this.className,
    required GetClassAccessories getClass,
    required SaveDressSizes saveSizes,
  }) : _get = getClass,
       _save = saveSizes,
       super(const DressSizesState()) {
    on<DressSizesStarted>((e, emit) async {
      final view = await _get(
        ClassAccessoriesParams(className, AccessoryKind.dress),
      );
      emit(
        state.copyWith(
          loading: false,
          view: view,
          sizes: {for (final r in view.rows) r.studentId: r.size ?? ''},
        ),
      );
    });
    on<DressSizeChanged>(
      (e, emit) =>
          emit(state.copyWith(sizes: {...state.sizes, e.studentId: e.size})),
    );
    on<DressSizesSaveRequested>((e, emit) async {
      emit(state.copyWith(saving: true));
      await _save(state.sizes);
      emit(state.copyWith(saving: false, saved: true));
    });
  }

  final String className;
  final GetClassAccessories _get;
  final SaveDressSizes _save;
}
