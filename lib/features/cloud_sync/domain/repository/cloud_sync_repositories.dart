import 'dart:async';

import '../entities/cloud_entities.dart';

/// row key → the row's columns, as they should be sent.
typedef SyncTableRows = Map<String, Map<String, Object?>>;

/// The phone's data, read for syncing.
abstract interface class SyncSourceRepository {
  /// The id that keeps this school's data apart in the cloud. Made the first
  /// time it is asked for.
  Future<String> schoolId();
  Future<String> schoolName();

  /// The active teachers and the classes they teach.
  Future<SchoolAccess> access();

  /// The synced tables, one per kind of school data.
  List<String> get tables;

  /// Every row of [table], with the columns that must stay on the phone
  /// (passwords, local file paths) already left out. One table at a time, so
  /// a big school never has all its data in memory at once.
  Future<SyncTableRows> table(String table);

  /// A name a person can recognise for [row] of [table] (a student's name, a
  /// notice's title, "Rahul · 5 Oct" for an attendance mark...).
  Future<String> describe(String table, Map<String, Object?> row);
}

/// What was sent last time, so only the difference is sent next time.
abstract interface class SyncStateRepository {
  /// row key → fingerprint, for what the cloud already has of [table].
  Future<Map<String, String>> hashesOf(String table);

  /// row key → the row as it was last sent (JSON), where it was kept.
  Future<Map<String, String>> snapshotsOf(String table);

  /// Remembers that [upserts] (key → fingerprint) were sent and [deletes]
  /// were removed.
  Future<void> apply(
    String table, {
    Map<String, String> upserts = const {},
    Map<String, String> snapshots = const {},
    Set<String> deletes = const {},
  });

  /// The last sync, even when it found nothing to send.
  Future<SyncRun?> lastRun();

  /// The last sync that actually sent or removed something.
  Future<SyncRun?> lastChangeRun();
  Future<void> saveRun(SyncRun run);
}

/// The cloud side. Everything may throw [CloudSyncException].
abstract interface class CloudStoreRepository {
  Future<CloudConnection> connection();

  /// Makes sure the school's space exists and belongs to the signed-in
  /// account.
  Future<void> ensureSchool(
    String schoolId,
    String schoolName,
    SchoolAccess access,
  );

  /// Writes [upserts] (key → row) and removes [deletes] in [table].
  Future<void> write(
    String schoolId,
    String table, {
    required Map<String, Map<String, Object?>> upserts,
    required Set<String> deletes,
  });
}

/// Brings the Principal's latest school data down to a Teacher's phone: the
/// school-wide settings, calendar (including whether today is a school day)
/// and notices, plus the teacher's own profile, class and students. Anything
/// the teacher records on their phone is left alone. May throw
/// [CloudSyncException].
abstract interface class SchoolPullRepository {
  Future<void> pull();
}

/// Question papers going from a Teacher to the Principal and the decisions
/// coming back.
abstract interface class PaperRequestsRepository {
  /// Teacher: sends the papers waiting for approval (only those changed since
  /// last time).
  Future<void> sendSubmitted();

  /// Teacher: copies the Principal's decisions onto the teacher's own papers.
  /// Returns true when something changed.
  Future<bool> applyDecisions();

  /// Principal: brings in new or re-sent requests. Returns those that are new.
  Future<List<PaperRequest>> importRequests();
}

/// Subjects teachers ask to teach, going to the Principal. (The Principal's
/// answer comes back with the normal sync of the Principal's phone.)
abstract interface class SubjectRequestsRepository {
  /// Teacher: sends the requests still waiting, and withdraws the ones the
  /// teacher cancelled.
  Future<void> sendPending();

  /// Principal: brings in new requests. Returns those that are new.
  Future<List<PaperRequest>> importRequests();
}

/// What teachers recorded on their phones, brought to the Principal's phone.
abstract interface class TeacherWorkRepository {
  /// Teacher check-ins and student attendance of the last days, and (with
  /// [withMarks]) exam marks. Returns true when something changed.
  Future<bool> importWork({bool withMarks = false});
}

/// How often the phone syncs by itself.
abstract interface class SyncSettingsRepository {
  /// Minutes between automatic syncs; 0 is off.
  Future<int> intervalMinutes();
  Future<void> saveIntervalMinutes(int minutes);
}

/// Tells the user that a sync is running, with a progress bar.
abstract interface class SyncNotifier {
  /// Starts listening for taps on the notification. Call once at app start.
  Future<void> init();

  /// Fires when the user taps the notification (also when that opened the app).
  Stream<void> get opened;

  /// Asks for the right to show notifications, where the phone requires it.
  Future<void> requestPermission();
  Future<void> show(SyncProgress progress);

  /// The sync finished: replaces the progress with a "saved" message that
  /// stays until the user swipes it away.
  Future<void> done(SyncRun run, {int? nextInMinutes});

  /// The sync did not finish: takes the notification away.
  Future<void> hide();

  /// The Principal's phone found papers teachers sent for approval.
  Future<void> approvalRequested(List<PaperRequest> requests);
}

/// Whether school data has changed since it was last sent to the cloud.
abstract interface class ChangeTrackerRepository {
  /// The number of the latest change.
  Future<int> latest();

  /// Whether anything changed after the last confirmed send.
  Future<bool> hasPending();

  /// Everything up to change [seq] is now in the cloud.
  Future<void> markSent(int seq);

  /// When school data last changed (null if never).
  Future<DateTime?> lastChangedAt();

  /// Anything changed after the data file was last written.
  Future<bool> hasUnmirrored();

  /// The data file now holds everything up to change [seq].
  Future<void> markMirrored(int seq);
}
