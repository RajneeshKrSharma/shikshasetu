import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/load_demo_data.dart';
import '../../domain/usecases/remove_demo_data.dart';

enum DemoDataStatus { idle, working, loaded, removed, failed }

class DemoDataState extends Equatable {
  const DemoDataState([this.status = DemoDataStatus.idle]);

  final DemoDataStatus status;

  bool get working => status == DemoDataStatus.working;

  @override
  List<Object?> get props => [status];
}

/// Adds or takes out the demo school.
class DemoDataCubit extends Cubit<DemoDataState> {
  DemoDataCubit({
    required LoadDemoData loadDemoData,
    required RemoveDemoData removeDemoData,
  }) : _load = loadDemoData,
       _remove = removeDemoData,
       super(const DemoDataState());

  final LoadDemoData _load;
  final RemoveDemoData _remove;

  Future<void> load() => _run(_load, DemoDataStatus.loaded);

  Future<void> remove() => _run(_remove, DemoDataStatus.removed);

  Future<void> _run(UseCase<void, NoParams> action, DemoDataStatus done) async {
    if (state.working) return;
    emit(const DemoDataState(DemoDataStatus.working));
    try {
      await action(const NoParams());
      emit(DemoDataState(done));
    } catch (_) {
      emit(const DemoDataState(DemoDataStatus.failed));
    }
  }
}
