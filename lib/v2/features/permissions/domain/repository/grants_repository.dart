import '../entities/grants.dart';

abstract interface class GrantsRepository {
  Future<List<Capability>> capabilities();

  Future<List<Grant>> grants(String userId);

  Future<void> grant(GrantDraft draft);

  Future<void> revoke(String grantId);
}
