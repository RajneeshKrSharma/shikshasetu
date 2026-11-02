import 'package:equatable/equatable.dart';

import 'accessory_issue.dart';

/// One handing over, with the student it was for.
class AccessoryRecord extends Equatable {
  const AccessoryRecord({
    required this.issue,
    required this.studentName,
    this.className,
  });

  final AccessoryIssue issue;
  final String studentName;
  final String? className;

  @override
  List<Object?> get props => [issue, studentName, className];
}
