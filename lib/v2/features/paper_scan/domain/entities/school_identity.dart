import 'package:equatable/equatable.dart';

/// The school's name and logo printed at the top of every paper.
class SchoolIdentity extends Equatable {
  const SchoolIdentity({this.name = '', this.logoPath});

  final String name;

  /// Where the logo picture is kept on the phone, if one was chosen.
  final String? logoPath;

  SchoolIdentity copyWith({String? name, String? logoPath}) => SchoolIdentity(
    name: name ?? this.name,
    logoPath: logoPath ?? this.logoPath,
  );

  @override
  List<Object?> get props => [name, logoPath];
}
