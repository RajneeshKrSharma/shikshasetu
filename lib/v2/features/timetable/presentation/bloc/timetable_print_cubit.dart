import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/server/server_exception.dart';
import '../../../../core/view_failure.dart';
import '../../domain/usecases/timetable_usecases.dart';

class TimetablePrintState extends Equatable {
  const TimetablePrintState({
    this.status = ViewStatus.loading,
    this.failure,
    this.pdf,
  });

  final ViewStatus status;
  final ViewFailure? failure;
  final Uint8List? pdf;

  @override
  List<Object?> get props => [status, failure, pdf];
}

class TimetablePrintCubit extends Cubit<TimetablePrintState> {
  TimetablePrintCubit(this._build) : super(const TimetablePrintState());

  final BuildTimetablePdf _build;

  Future<void> load(BuildTimetablePdfParams params) async {
    emit(const TimetablePrintState());
    try {
      emit(
        TimetablePrintState(
          status: ViewStatus.ready,
          pdf: await _build(params),
        ),
      );
    } on ServerException catch (error) {
      emit(
        TimetablePrintState(
          status: ViewStatus.failed,
          failure: ViewFailure.from(error),
        ),
      );
    }
  }
}
