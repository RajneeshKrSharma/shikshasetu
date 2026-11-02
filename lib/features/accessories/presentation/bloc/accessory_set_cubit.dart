import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/accessory_kind.dart';
import '../../domain/usecases/accessories_usecases.dart';

class AccessorySetState extends Equatable {
  const AccessorySetState({
    this.loading = true,
    this.kind = AccessoryKind.dress,
    this.className,
    this.items = const [],
    this.addedCount = 0,
  });

  final bool loading;
  final AccessoryKind kind;
  final String? className;

  /// The names of the pieces (or books) in the chosen class's set.
  final List<String> items;

  /// Goes up each time an item is added, so the screen can say so once.
  final int addedCount;

  AccessorySetState copyWith({
    bool? loading,
    AccessoryKind? kind,
    String? className,
    List<String>? items,
    int? addedCount,
  }) => AccessorySetState(
    loading: loading ?? this.loading,
    kind: kind ?? this.kind,
    className: className ?? this.className,
    items: items ?? this.items,
    addedCount: addedCount ?? this.addedCount,
  );

  @override
  List<Object?> get props => [loading, kind, className, items, addedCount];
}

/// The dress set or the book list of one class: add a piece, rename one, or
/// take one away.
class AccessorySetCubit extends Cubit<AccessorySetState> {
  AccessorySetCubit({
    String? firstClass,
    required GetClassAccessories getClass,
    required SaveAccessoryItems saveItems,
  }) : _getClass = getClass,
       _save = saveItems,
       super(AccessorySetState(className: firstClass));

  final GetClassAccessories _getClass;
  final SaveAccessoryItems _save;

  Future<void> load() async {
    final className = state.className;
    if (className == null) {
      emit(state.copyWith(loading: false));
      return;
    }
    final view = await _getClass(ClassAccessoriesParams(className, state.kind));
    if (isClosed) return;
    emit(
      state.copyWith(
        loading: false,
        items: [for (final i in view.items) i.name],
      ),
    );
  }

  Future<void> kindChosen(AccessoryKind kind) async {
    emit(state.copyWith(kind: kind));
    await load();
  }

  Future<void> classChosen(String className) async {
    emit(state.copyWith(className: className));
    await load();
  }

  Future<void> _store(List<String> names) async {
    final className = state.className;
    if (className == null) return;
    await _save(SaveAccessoryItemsParams(className, state.kind, names));
    await load();
  }

  Future<void> add(String name) async {
    await _store([...state.items, name]);
    emit(state.copyWith(addedCount: state.addedCount + 1));
  }

  Future<void> rename(String from, String to) =>
      _store([for (final n in state.items) n == from ? to : n]);

  Future<void> remove(String name) => _store([
    for (final n in state.items)
      if (n != name) n,
  ]);
}
