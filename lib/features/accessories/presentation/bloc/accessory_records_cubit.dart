import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/accessory_record.dart';
import '../../domain/usecases/accessories_usecases.dart';

class AccessoryRecordsState extends Equatable {
  const AccessoryRecordsState({this.loading = true, this.records = const []});

  final bool loading;

  /// Newest first.
  final List<AccessoryRecord> records;

  @override
  List<Object?> get props => [loading, records];
}

/// Everything that was given to any student.
class AccessoryRecordsCubit extends Cubit<AccessoryRecordsState> {
  AccessoryRecordsCubit({required GetAccessoryRecords getRecords})
    : _get = getRecords,
      super(const AccessoryRecordsState());

  final GetAccessoryRecords _get;

  Future<void> load() async => emit(
    AccessoryRecordsState(
      loading: false,
      records: await _get(const NoParams()),
    ),
  );
}
