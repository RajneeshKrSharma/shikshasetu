import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/fee_account.dart';
import '../../domain/entities/fee_structure_item.dart';
import '../../domain/usecases/fee_structure_usecases.dart';

sealed class FeeSetupEvent extends Equatable {
  const FeeSetupEvent();

  @override
  List<Object?> get props => const [];
}

final class FeeSetupStarted extends FeeSetupEvent {
  const FeeSetupStarted();
}

final class FeeSetupClassChosen extends FeeSetupEvent {
  const FeeSetupClassChosen(this.className);

  final String className;

  @override
  List<Object?> get props => [className];
}

final class FeeSetupItemSaved extends FeeSetupEvent {
  const FeeSetupItemSaved(this.item);

  final FeeStructureItem item;

  @override
  List<Object?> get props => [item];
}

/// Give the class's students the fee of [head].
final class FeeSetupApplied extends FeeSetupEvent {
  const FeeSetupApplied(this.head);

  final FeeHead head;

  @override
  List<Object?> get props => [head];
}

class FeeSetupState extends Equatable {
  const FeeSetupState({
    this.loading = true,
    this.structure = const [],
    this.className,
    this.appliedId = 0,
    this.appliedCount = 0,
    this.appliedHead,
  });

  final bool loading;
  final List<FeeStructureItem> structure;
  final String? className;

  /// Goes up each time a fee is given to students, so the screen can say so.
  final int appliedId;
  final int appliedCount;
  final FeeHead? appliedHead;

  /// What the chosen class pays for [head]; null if not set up yet.
  FeeStructureItem? itemOf(FeeHead head) {
    for (final i in structure) {
      if (i.className == className && i.head == head) return i;
    }
    return null;
  }

  FeeSetupState copyWith({
    bool? loading,
    List<FeeStructureItem>? structure,
    String? className,
    int? appliedId,
    int? appliedCount,
    FeeHead? appliedHead,
  }) => FeeSetupState(
    loading: loading ?? this.loading,
    structure: structure ?? this.structure,
    className: className ?? this.className,
    appliedId: appliedId ?? this.appliedId,
    appliedCount: appliedCount ?? this.appliedCount,
    appliedHead: appliedHead ?? this.appliedHead,
  );

  @override
  List<Object?> get props => [
    loading,
    structure,
    className,
    appliedId,
    appliedCount,
    appliedHead,
  ];
}

/// Setting what each class pays, and giving it to the class's students.
class FeeSetupBloc extends Bloc<FeeSetupEvent, FeeSetupState> {
  FeeSetupBloc({
    required GetFeeStructure getStructure,
    required SaveFeeStructureItem saveItem,
    required ApplyFeeStructure apply,
    String? firstClass,
  }) : _get = getStructure,
       _save = saveItem,
       _apply = apply,
       super(FeeSetupState(className: firstClass)) {
    on<FeeSetupStarted>(
      (e, emit) async => emit(
        state.copyWith(loading: false, structure: await _get(const NoParams())),
      ),
    );
    on<FeeSetupClassChosen>(
      (e, emit) => emit(state.copyWith(className: e.className)),
    );
    on<FeeSetupItemSaved>((e, emit) async {
      await _save(e.item);
      emit(state.copyWith(structure: await _get(const NoParams())));
    });
    on<FeeSetupApplied>((e, emit) async {
      final count = await _apply(
        ApplyFeeStructureParams(state.className!, e.head),
      );
      emit(
        state.copyWith(
          appliedId: state.appliedId + 1,
          appliedCount: count,
          appliedHead: e.head,
        ),
      );
    });
  }

  final GetFeeStructure _get;
  final SaveFeeStructureItem _save;
  final ApplyFeeStructure _apply;
}
