import 'package:equatable/equatable.dart';

/// One business action. Implementations expose a single [call].
abstract interface class UseCase<Output, Params> {
  Future<Output> call(Params params);
}

/// For use cases that need no input.
final class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => const [];
}
