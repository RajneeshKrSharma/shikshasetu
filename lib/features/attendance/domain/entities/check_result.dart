import 'package:equatable/equatable.dart';

import 'check_point.dart';

enum CheckFailure {
  schoolClosed,
  locationNotConfigured,
  servicesOff,
  permissionDenied,
  permissionDeniedForever,
  locationUnavailable,
  mockLocation,
  outsideSchool,
  selfieCancelled,

  /// Face ID: the face is not the teacher's, none was found, or the face
  /// model could not run.
  faceMismatch,
  faceNotFound,
  faceUnavailable,
}

class CheckResult extends Equatable {
  const CheckResult.ok(CheckPoint this.point) : failure = null, distance = null;
  const CheckResult.fail(CheckFailure this.failure, {this.distance})
    : point = null;

  final CheckPoint? point;
  final CheckFailure? failure;

  /// Distance in metres when the failure was [CheckFailure.outsideSchool].
  final double? distance;

  bool get ok => failure == null;

  @override
  List<Object?> get props => [point, failure, distance];
}
