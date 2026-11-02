import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/accessory_kind.dart';
import '../../domain/entities/class_accessories.dart';
import '../../domain/usecases/accessories_usecases.dart';

sealed class AccessoriesEvent extends Equatable {
  const AccessoriesEvent();

  @override
  List<Object?> get props => const [];
}

final class AccessoriesStarted extends AccessoriesEvent {
  const AccessoriesStarted();
}

final class AccessoryKindChosen extends AccessoriesEvent {
  const AccessoryKindChosen(this.kind);

  final AccessoryKind kind;

  @override
  List<Object?> get props => [kind];
}

final class AccessoryClassChosen extends AccessoriesEvent {
  const AccessoryClassChosen(this.className);

  final String className;

  @override
  List<Object?> get props => [className];
}

/// Something changed (an item was given, a size noted): read it again.
final class AccessoriesReloaded extends AccessoriesEvent {
  const AccessoriesReloaded();
}

final class AccessorySetSaved extends AccessoriesEvent {
  const AccessorySetSaved(this.names);

  final List<String> names;

  @override
  List<Object?> get props => [names];
}

class AccessoriesState extends Equatable {
  const AccessoriesState({
    this.loading = true,
    this.kind = AccessoryKind.dress,
    this.className,
    this.view,
  });

  final bool loading;
  final AccessoryKind kind;
  final String? className;
  final ClassAccessories? view;

  AccessoriesState copyWith({
    bool? loading,
    AccessoryKind? kind,
    String? className,
    ClassAccessories? view,
  }) => AccessoriesState(
    loading: loading ?? this.loading,
    kind: kind ?? this.kind,
    className: className ?? this.className,
    view: view ?? this.view,
  );

  @override
  List<Object?> get props => [loading, kind, className, view];
}

/// Dress or books of one class: its set, and who has been given what.
class AccessoriesBloc extends Bloc<AccessoriesEvent, AccessoriesState> {
  AccessoriesBloc({
    required GetClassAccessories getClass,
    required SaveAccessoryItems saveItems,
    String? firstClass,
  }) : _get = getClass,
       _saveItems = saveItems,
       super(AccessoriesState(className: firstClass)) {
    on<AccessoriesStarted>((e, emit) => _load(emit));
    on<AccessoriesReloaded>((e, emit) => _load(emit));
    on<AccessoryKindChosen>((e, emit) async {
      emit(state.copyWith(kind: e.kind));
      await _load(emit);
    });
    on<AccessoryClassChosen>((e, emit) async {
      emit(state.copyWith(className: e.className));
      await _load(emit);
    });
    on<AccessorySetSaved>((e, emit) async {
      await _saveItems(
        SaveAccessoryItemsParams(state.className!, state.kind, e.names),
      );
      await _load(emit);
    });
  }

  final GetClassAccessories _get;
  final SaveAccessoryItems _saveItems;

  Future<void> _load(Emitter<AccessoriesState> emit) async {
    final className = state.className;
    if (className == null) {
      emit(state.copyWith(loading: false));
      return;
    }
    emit(
      state.copyWith(
        loading: false,
        view: await _get(ClassAccessoriesParams(className, state.kind)),
      ),
    );
  }
}
