import '../../../../core/usecase/usecase.dart';
import '../entities/scanned_question.dart';
import '../repository/photo_picker_repository.dart';

class PickPhoto implements UseCase<String?, PhotoSource> {
  const PickPhoto(this._repository);

  final PhotoPickerRepository _repository;

  @override
  Future<String?> call(PhotoSource source) => _repository.pick(source);
}
