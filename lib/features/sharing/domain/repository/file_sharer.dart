abstract interface class FileSharer {
  /// Opens the system share sheet. Returns true if the user shared the files.
  Future<bool> share(List<String> paths, {String? subject});
}
