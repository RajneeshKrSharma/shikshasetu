import '../../../members/domain/repository/member_repository.dart';
import '../entities/student.dart';

abstract interface class StudentsRepository
    implements MemberRepository<Student> {
  /// The active students of a class, ordered by roll number.
  Future<List<Student>> getByClass(String classSection);

  /// The van numbers of the active drivers, to choose a student's van from.
  Future<List<String>> getVehicleNumbers();
}
