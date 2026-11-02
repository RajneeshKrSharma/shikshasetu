abstract interface class AiKeyRepository {
  Future<String?> load();
  Future<void> save(String key);
  Future<void> clear();
}
