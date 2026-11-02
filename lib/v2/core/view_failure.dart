import 'package:equatable/equatable.dart';

import 'server/server_exception.dart';

/// A problem a screen shows to the person: what kind it was, and the server's
/// own sentence when it gave one.
class ViewFailure extends Equatable {
  const ViewFailure(this.kind, {this.message, this.fields = const {}});

  /// Turns whatever went wrong into something a screen can show.
  factory ViewFailure.from(Object error) => error is ServerException
      ? ViewFailure(error.failure, message: error.message, fields: error.fields)
      : const ViewFailure(ServerFailure.unavailable);

  final ServerFailure kind;
  final String? message;

  /// What was wrong with each field, when the server said.
  final Map<String, List<String>> fields;

  /// The first thing wrong with [field], if anything.
  String? onField(String field) {
    final texts = fields[field];
    return texts == null || texts.isEmpty ? null : texts.first;
  }

  @override
  List<Object?> get props => [kind, message, fields];
}

/// Where a screen's data stands.
enum ViewStatus { loading, ready, failed }
