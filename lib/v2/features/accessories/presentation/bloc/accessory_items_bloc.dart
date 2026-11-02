import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../../students/domain/entities/school_class.dart';
import '../../../students/domain/usecases/classes_usecases.dart';
import '../../domain/entities/accessory.dart';
import '../../domain/usecases/accessories_usecases.dart';

sealed class AccessoryItemsEvent extends Equatable {
  const AccessoryItemsEvent();

  @override
  List<Object?> get props => const [];
}

final class AccessoryItemsStarted extends AccessoryItemsEvent {
  const AccessoryItemsStarted();
}

final class AccessoryKindChosen extends AccessoryItemsEvent {
  const AccessoryKindChosen(this.kind);

  final AccessoryKind? kind;

  @override
  List<Object?> get props => [kind];
}

final class AccessoryItemSaved extends AccessoryItemsEvent {
  const AccessoryItemSaved(this.draft);

  final AccessoryItemDraft draft;

  @override
  List<Object?> get props => [draft];
}

final class AccessoryItemRemoved extends AccessoryItemsEvent {
  const AccessoryItemRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class AccessoryItemsState extends Equatable {
  const AccessoryItemsState({
    this.status = ViewStatus.loading,
    this.failure,
    this.items = const [],
    this.classes = const [],
    this.kind,
    this.busy = false,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final List<AccessoryItem> items;
  final List<SchoolClass> classes;

  /// null shows both kinds.
  final AccessoryKind? kind;
  final bool busy;

  AccessoryItemsState copyWith({
    ViewStatus? status,
    ViewFailure? failure,
    bool clearFailure = false,
    List<AccessoryItem>? items,
    List<SchoolClass>? classes,
    AccessoryKind? kind,
    bool clearKind = false,
    bool? busy,
  }) => AccessoryItemsState(
    status: status ?? this.status,
    failure: clearFailure ? null : (failure ?? this.failure),
    items: items ?? this.items,
    classes: classes ?? this.classes,
    kind: clearKind ? null : (kind ?? this.kind),
    busy: busy ?? this.busy,
  );

  @override
  List<Object?> get props => [status, failure, items, classes, kind, busy];
}

class AccessoryItemsBloc
    extends Bloc<AccessoryItemsEvent, AccessoryItemsState> {
  AccessoryItemsBloc({
    required GetAccessoryItems getItems,
    required SaveAccessoryItem saveItem,
    required RemoveAccessoryItem removeItem,
    required GetClasses getClasses,
  }) : _items = getItems,
       _save = saveItem,
       _remove = removeItem,
       _classes = getClasses,
       super(const AccessoryItemsState()) {
    on<AccessoryItemsStarted>(_onStarted);
    on<AccessoryKindChosen>(
      (e, emit) => _reload(
        emit,
        state.copyWith(kind: e.kind, clearKind: e.kind == null),
      ),
    );
    on<AccessoryItemSaved>((e, emit) => _change(emit, () => _save(e.draft)));
    on<AccessoryItemRemoved>((e, emit) => _change(emit, () => _remove(e.id)));
  }

  final GetAccessoryItems _items;
  final SaveAccessoryItem _save;
  final RemoveAccessoryItem _remove;
  final GetClasses _classes;

  Future<void> _onStarted(
    AccessoryItemsStarted e,
    Emitter<AccessoryItemsState> emit,
  ) async {
    try {
      emit(state.copyWith(classes: await _classes(const NoParams())));
      await _reload(emit, state);
    } on ServerException catch (error) {
      emit(
        state.copyWith(
          status: ViewStatus.failed,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }

  Future<void> _reload(
    Emitter<AccessoryItemsState> emit,
    AccessoryItemsState base,
  ) async {
    emit(base.copyWith(status: ViewStatus.loading, clearFailure: true));
    try {
      emit(
        base.copyWith(
          status: ViewStatus.ready,
          items: await _items(GetItemsParams(kind: base.kind)),
        ),
      );
    } on ServerException catch (error) {
      emit(
        base.copyWith(
          status: ViewStatus.failed,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }

  Future<void> _change(
    Emitter<AccessoryItemsState> emit,
    Future<Object?> Function() action,
  ) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    try {
      await action();
      emit(
        state.copyWith(
          busy: false,
          items: await _items(GetItemsParams(kind: state.kind)),
        ),
      );
    } on ServerException catch (error) {
      emit(state.copyWith(busy: false, failure: ViewFailure.from(error)));
    }
  }
}
