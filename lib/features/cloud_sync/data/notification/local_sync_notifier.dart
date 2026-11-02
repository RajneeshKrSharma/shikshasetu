import 'dart:ui';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/sync_l10n.dart';
import '../../domain/entities/cloud_entities.dart';
import '../../domain/repository/cloud_sync_repositories.dart';

/// The "Syncing data to server" notification with a progress bar. Needs no
/// screen, so the text is looked up for the phone's language instead of
/// coming from a BuildContext.
class LocalSyncNotifier implements SyncNotifier {
  LocalSyncNotifier({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const _id = 7001;
  static const _channelId = 'cloud_sync';

  /// A sync can finish in well under a second; the notification stays this
  /// long so it can actually be seen.
  static const _minVisible = Duration(seconds: 3);

  DateTime? _shownAt;

  AppLocalizations get _l {
    final device = PlatformDispatcher.instance.locale;
    final supported = AppLocalizations.supportedLocales.any(
      (l) => l.languageCode == device.languageCode,
    );
    return lookupAppLocalizations(supported ? device : const Locale('en'));
  }

  final _opened = StreamController<void>.broadcast();

  static const _payload = 'sync';

  /// Set up on first use. A tap that started the app is reported too.
  late final Future<void> _ready = _setUp();

  Future<void> _setUp() async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_stat_sync'),
      ),
      onDidReceiveNotificationResponse: (r) {
        if (r.payload == _payload) _opened.add(null);
      },
    );
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp == true &&
        launch?.notificationResponse?.payload == _payload) {
      // Let the app finish starting before anyone is told.
      Future<void>.delayed(const Duration(milliseconds: 500), () {
        _opened.add(null);
      });
    }
  }

  @override
  Stream<void> get opened => _opened.stream;

  @override
  Future<void> init() => _bestEffort(() => _ready);

  static const _largeIcon = DrawableResourceAndroidBitmap('sync_large_icon');

  /// Android 13+ asks before any notification may be shown.
  @override
  Future<void> requestPermission() => _bestEffort(() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    await _ready;
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  });

  /// A notification is a courtesy: when it cannot be shown (permission
  /// denied, plugin not available), the sync itself must carry on.
  Future<void> _bestEffort(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      debugPrint('Sync notification skipped: $e');
    }
  }

  @override
  Future<void> show(SyncProgress progress) => _bestEffort(() async {
    final l = _l;
    await _ready;
    _shownAt ??= DateTime.now();
    await _plugin.show(
      id: _id,
      title: l.syncNotifTitle,
      body: progress.feature == null
          ? l.syncNotifProgress(progress.done, progress.total)
          : l.syncNotifChecking(
              progress.feature!.label(l),
              progress.done + 1,
              progress.total,
            ),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          l.syncNotifChannel,
          // Quiet: no sound or vibration, just the progress bar.
          importance: Importance.low,
          priority: Priority.low,
          playSound: false,
          enableVibration: false,
          onlyAlertOnce: true,
          ongoing: true,
          autoCancel: false,
          showWhen: false,
          showProgress: true,
          maxProgress: progress.total,
          progress: progress.done,
          icon: 'ic_stat_sync',
          largeIcon: _largeIcon,
        ),
      ),
      payload: _payload,
    );
  });

  @override
  Future<void> done(SyncRun run, {int? nextInMinutes}) => _bestEffort(() async {
    await _waitMinVisible();
    final l = _l;
    await _ready;
    final time = DateFormat.jm(
      PlatformDispatcher.instance.locale.toString(),
    ).format(run.at);
    final features = {
      ...run.uploadedByFeature.keys,
      ...run.deletedByFeature.keys,
    }.length;
    // One short line; the details open on tapping the notification.
    final summary = run.isEmpty
        ? '${l.syncNotifUpToDate} · $time'
        : [
            if (run.totalUploaded > 0) l.cloudSentSummary(run.totalUploaded),
            if (run.totalDeleted > 0) l.cloudRemovedSummary(run.totalDeleted),
            l.syncFeaturesCount(features),
            time,
          ].join(' · ');
    await _plugin.show(
      id: _id,
      title: l.syncNotifDone,
      body: summary,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          l.syncNotifChannel,
          importance: Importance.low,
          priority: Priority.low,
          playSound: false,
          enableVibration: false,
          onlyAlertOnce: true,
          // Stays until swiped away.
          ongoing: false,
          autoCancel: true,
          icon: 'ic_stat_sync',
          largeIcon: _largeIcon,
          styleInformation: BigPictureStyleInformation(
            const DrawableResourceAndroidBitmap('sync_banner'),
            largeIcon: _largeIcon,
            contentTitle: l.syncNotifDone,
            summaryText: [
              summary,
              if (nextInMinutes != null)
                l.syncNotifNext(syncIntervalLabel(l, nextInMinutes)),
              l.syncNotifTapHint,
            ].join('\n'),
            hideExpandedLargeIcon: true,
          ),
        ),
      ),
      payload: _payload,
    );
  });

  @override
  Future<void> approvalRequested(List<PaperRequest> requests) =>
      _bestEffort(() async {
        if (requests.isEmpty) return;
        final l = _l;
        await _ready;
        final one = requests.length == 1;
        await _plugin.show(
          id: 7002,
          title: one
              ? l.approvalNotifOneTitle
              : l.approvalNotifManyTitle(requests.length),
          body: one
              ? l.approvalNotifOneBody(
                  requests.first.teacherName,
                  requests.first.title,
                )
              : l.approvalNotifManyBody,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              'approvals',
              l.approvalNotifChannel,
              importance: Importance.high,
              priority: Priority.high,
              icon: 'ic_stat_sync',
              largeIcon: _largeIcon,
            ),
          ),
        );
      });

  @override
  Future<void> hide() => _bestEffort(() async {
    await _waitMinVisible();
    await _plugin.cancel(id: _id);
  });

  /// Holds back until the progress notification has been up for
  /// [_minVisible], then forgets it.
  Future<void> _waitMinVisible() async {
    final shownAt = _shownAt;
    if (shownAt == null) return;
    final left = _minVisible - DateTime.now().difference(shownAt);
    if (!left.isNegative) await Future<void>.delayed(left);
    _shownAt = null;
  }
}
