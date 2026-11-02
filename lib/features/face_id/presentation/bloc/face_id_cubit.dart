import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/face_entities.dart';
import '../../domain/usecases/face_usecases.dart';

enum FaceIdNotice { setUp, removed, notFound, unavailable }

class FaceIdArgs {
  const FaceIdArgs({
    required this.teacherId,
    required this.teacherName,
    this.enrolledBy,
  });

  final String teacherId;
  final String teacherName;

  /// Who is doing the set-up (the Principal, or the teacher themself).
  final String? enrolledBy;
}

class FaceIdState extends Equatable {
  const FaceIdState({
    this.loading = true,
    this.enrolledAt,
    this.busy = false,
    this.notice,
    this.noticeId = 0,
  });

  final bool loading;

  /// When Face ID was set up; null if it is not set up.
  final DateTime? enrolledAt;
  final bool busy;
  final FaceIdNotice? notice;
  final int noticeId;

  bool get isEnrolled => enrolledAt != null;

  @override
  List<Object?> get props => [loading, enrolledAt, busy, notice, noticeId];
}

/// One teacher's Face ID: whether it is set up, and setting it up or removing it.
class FaceIdCubit extends Cubit<FaceIdState> {
  FaceIdCubit({
    required this.args,
    required GetFaceEnrollment getFaceEnrollment,
    required SetUpFace setUpFace,
    required RemoveFace removeFace,
  }) : _get = getFaceEnrollment,
       _setUp = setUpFace,
       _remove = removeFace,
       super(const FaceIdState());

  final FaceIdArgs args;
  final GetFaceEnrollment _get;
  final SetUpFace _setUp;
  final RemoveFace _remove;

  int _noticeCounter = 0;

  Future<void> load() async =>
      emit(FaceIdState(loading: false, enrolledAt: await _get(args.teacherId)));

  void _tell(FaceIdNotice notice, DateTime? enrolledAt) => emit(
    FaceIdState(
      loading: false,
      enrolledAt: enrolledAt,
      notice: notice,
      noticeId: ++_noticeCounter,
    ),
  );

  Future<void> setUp() async {
    if (state.busy) return;
    emit(
      FaceIdState(
        loading: false,
        enrolledAt: state.enrolledAt,
        busy: true,
        notice: state.notice,
        noticeId: state.noticeId,
      ),
    );
    try {
      final done = await _setUp(
        SetUpFaceParams(
          teacherId: args.teacherId,
          teacherName: args.teacherName,
          enrolledBy: args.enrolledBy,
        ),
      );
      if (done) {
        _tell(FaceIdNotice.setUp, await _get(args.teacherId));
      } else {
        emit(FaceIdState(loading: false, enrolledAt: state.enrolledAt));
      }
    } on FaceException catch (e) {
      _tell(
        e.problem == FaceProblem.notFound
            ? FaceIdNotice.notFound
            : FaceIdNotice.unavailable,
        state.enrolledAt,
      );
    } catch (_) {
      _tell(FaceIdNotice.unavailable, state.enrolledAt);
    }
  }

  Future<void> remove() async {
    await _remove(args.teacherId);
    _tell(FaceIdNotice.removed, null);
  }
}
