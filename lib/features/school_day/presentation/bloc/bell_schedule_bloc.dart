import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/bell_slot.dart';
import '../../domain/usecases/school_day_usecases.dart';

sealed class BellScheduleEvent extends Equatable {
  const BellScheduleEvent();

  @override
  List<Object?> get props => const [];
}

final class BellScheduleStarted extends BellScheduleEvent {
  const BellScheduleStarted();
}

final class BellSlotSaved extends BellScheduleEvent {
  const BellSlotSaved(this.slot);

  final BellSlot slot;

  @override
  List<Object?> get props => [slot];
}

final class BellSlotRemoved extends BellScheduleEvent {
  const BellSlotRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class BellScheduleState extends Equatable {
  const BellScheduleState({this.loading = true, this.slots = const []});

  final bool loading;
  final List<BellSlot> slots;

  /// The number of a period among the periods (breaks are not counted).
  int numberOf(BellSlot slot) =>
      slots.where((s) => s.isPeriod && s.position <= slot.position).length;

  @override
  List<Object?> get props => [loading, slots];
}

/// The school's bell: every period and break of the day.
class BellScheduleBloc extends Bloc<BellScheduleEvent, BellScheduleState> {
  BellScheduleBloc({
    required GetBellSlots getSlots,
    required SaveBellSlot saveSlot,
    required DeleteBellSlot deleteSlot,
  }) : _get = getSlots,
       _save = saveSlot,
       _delete = deleteSlot,
       super(const BellScheduleState()) {
    on<BellScheduleStarted>((e, emit) => _load(emit));
    on<BellSlotSaved>((e, emit) async {
      await _save(e.slot);
      await _load(emit);
    });
    on<BellSlotRemoved>((e, emit) async {
      await _delete(e.id);
      await _load(emit);
    });
  }

  final GetBellSlots _get;
  final SaveBellSlot _save;
  final DeleteBellSlot _delete;

  Future<void> _load(Emitter<BellScheduleState> emit) async => emit(
    BellScheduleState(loading: false, slots: await _get(const NoParams())),
  );
}
