import 'package:equatable/equatable.dart';

import 'sync_feature.dart';
import 'sync_record_change.dart';

/// What one exchange with the other side moved: the records this phone sent
/// and the ones it received that were new or changed, per table.
class SyncActivity extends Equatable {
  const SyncActivity({
    required this.at,
    this.sent = const {},
    this.received = const {},
    this.sentChanges = const [],
    this.receivedChanges = const [],
  });

  final DateTime at;
  final Map<String, int> sent;
  final Map<String, int> received;

  /// The records themselves (the first few hundred of a round), with what
  /// changed in each. The counts above are always complete.
  final List<SyncRecordChange> sentChanges;
  final List<SyncRecordChange> receivedChanges;

  Map<SyncFeature, int> get sentByFeature => _byFeature(sent);
  Map<SyncFeature, int> get receivedByFeature => _byFeature(received);

  static Map<SyncFeature, int> _byFeature(Map<String, int> perTable) {
    final result = <SyncFeature, int>{};
    for (final e in perTable.entries) {
      result.update(
        SyncFeature.ofTable(e.key),
        (n) => n + e.value,
        ifAbsent: () => e.value,
      );
    }
    return result;
  }

  int get totalSent => sent.values.fold(0, (a, b) => a + b);
  int get totalReceived => received.values.fold(0, (a, b) => a + b);

  /// Nothing was sent and nothing new came in.
  bool get isEmpty => totalSent == 0 && totalReceived == 0;

  @override
  List<Object?> get props => [at, sent, received, sentChanges, receivedChanges];
}

/// Collects what the sync steps move while a round runs. Each step reports
/// into it; the round then takes the total.
class SyncActivityLog {
  final Map<String, int> _sent = {};
  final Map<String, int> _received = {};
  final List<SyncRecordChange> _sentChanges = [];
  final List<SyncRecordChange> _receivedChanges = [];

  /// Most records kept per round and direction, so a first sync of a big
  /// school does not fill the memory.
  static const maxRecords = 300;

  /// A record this phone sent.
  void recordSent(SyncRecordChange c) {
    sent(c.table);
    if (_sentChanges.length < maxRecords) _sentChanges.add(c);
  }

  /// A new or changed record this phone received.
  void recordReceived(SyncRecordChange c) {
    received(c.table);
    if (_receivedChanges.length < maxRecords) _receivedChanges.add(c);
  }

  void sent(String table, [int count = 1]) {
    if (count > 0) _sent.update(table, (n) => n + count, ifAbsent: () => count);
  }

  void received(String table, [int count = 1]) {
    if (count > 0) {
      _received.update(table, (n) => n + count, ifAbsent: () => count);
    }
  }

  /// What was reported since the last call, as one round at [at].
  SyncActivity take(DateTime at) {
    final activity = SyncActivity(
      at: at,
      sent: Map.of(_sent),
      received: Map.of(_received),
      sentChanges: List.of(_sentChanges),
      receivedChanges: List.of(_receivedChanges),
    );
    _sent.clear();
    _received.clear();
    _sentChanges.clear();
    _receivedChanges.clear();
    return activity;
  }
}
