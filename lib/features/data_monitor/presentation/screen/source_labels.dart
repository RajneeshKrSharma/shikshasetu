import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/data_source_kind.dart';
import '../../domain/entities/source_summary.dart';

extension DataSourceKindStyle on DataSourceKind {
  String label(AppLocalizations l) => switch (this) {
    DataSourceKind.cloud => l.monSrcCloud,
    DataSourceKind.file => l.monSrcFile,
    DataSourceKind.localDb => l.monSrcDb,
  };

  IconData get icon => switch (this) {
    DataSourceKind.cloud => Icons.cloud_outlined,
    DataSourceKind.file => Icons.description_outlined,
    DataSourceKind.localDb => Icons.smartphone,
  };
}

extension SourceProblemLabel on SourceProblem {
  String label(AppLocalizations l) => switch (this) {
    SourceProblem.missing => l.monProblemMissing,
    SourceProblem.notSignedIn => l.monProblemNotSignedIn,
    SourceProblem.offline => l.monProblemOffline,
    SourceProblem.other => l.monProblemOther,
  };
}
