/// One thing a screen can keep listening to. Implementations expose a single
/// [call] that returns the stream.
abstract interface class StreamUseCase<Output, Params> {
  Stream<Output> call(Params params);
}
