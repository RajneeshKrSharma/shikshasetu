import 'package:equatable/equatable.dart';

/// A holiday the school may want on its list, offered as a suggestion.
class SuggestedHoliday extends Equatable {
  const SuggestedHoliday({
    required this.date,
    required this.nameEn,
    required this.nameHi,
    required this.movesEachYear,
  });

  final DateTime date;
  final String nameEn;
  final String nameHi;

  /// Follows the moon or a religious calendar, so the date should be checked.
  final bool movesEachYear;

  String name({required bool hindi}) => hindi ? nameHi : nameEn;

  @override
  List<Object?> get props => [date, nameEn, nameHi, movesEachYear];
}

/// Public holidays of India that schools commonly close for.
///
/// The national days fall on the same date every year. Festival dates move,
/// so they are listed only for the years below and should be checked against
/// the official calendar before saving.
class IndianHolidays {
  const IndianHolidays._();

  static List<SuggestedHoliday> forYear(int year) {
    final all = <SuggestedHoliday>[
      for (final (m, d, en, hi) in _fixed)
        SuggestedHoliday(
          date: DateTime(year, m, d),
          nameEn: en,
          nameHi: hi,
          movesEachYear: false,
        ),
      for (final (m, d, en, hi)
          in _festivals[year] ?? const <(int, int, String, String)>[])
        SuggestedHoliday(
          date: DateTime(year, m, d),
          nameEn: en,
          nameHi: hi,
          movesEachYear: true,
        ),
    ]..sort((a, b) => a.date.compareTo(b.date));
    return all;
  }

  static const _fixed = <(int, int, String, String)>[
    (1, 26, 'Republic Day', 'गणतंत्र दिवस'),
    (4, 14, 'Ambedkar Jayanti', 'अम्बेडकर जयंती'),
    (8, 15, 'Independence Day', 'स्वतंत्रता दिवस'),
    (10, 2, 'Gandhi Jayanti', 'गांधी जयंती'),
    (12, 25, 'Christmas', 'क्रिसमस'),
  ];

  static const _festivals = <int, List<(int, int, String, String)>>{
    2026: [
      (2, 15, 'Maha Shivratri', 'महाशिवरात्रि'),
      (3, 4, 'Holi', 'होली'),
      (3, 21, 'Eid-ul-Fitr', 'ईद-उल-फ़ित्र'),
      (3, 26, 'Ram Navami', 'राम नवमी'),
      (3, 31, 'Mahavir Jayanti', 'महावीर जयंती'),
      (4, 3, 'Good Friday', 'गुड फ्राइडे'),
      (5, 1, 'Buddha Purnima', 'बुद्ध पूर्णिमा'),
      (5, 27, 'Bakrid (Eid-ul-Adha)', 'बकरीद (ईद-उल-अज़हा)'),
      (6, 26, 'Muharram', 'मुहर्रम'),
      (8, 28, 'Raksha Bandhan', 'रक्षाबंधन'),
      (9, 4, 'Janmashtami', 'जन्माष्टमी'),
      (9, 14, 'Ganesh Chaturthi', 'गणेश चतुर्थी'),
      (10, 20, 'Dussehra', 'दशहरा'),
      (11, 8, 'Diwali', 'दीवाली'),
      (11, 24, 'Guru Nanak Jayanti', 'गुरु नानक जयंती'),
    ],
    2027: [
      (3, 6, 'Maha Shivratri', 'महाशिवरात्रि'),
      (3, 10, 'Eid-ul-Fitr', 'ईद-उल-फ़ित्र'),
      (3, 22, 'Holi', 'होली'),
      (3, 26, 'Good Friday', 'गुड फ्राइडे'),
      (4, 15, 'Ram Navami', 'राम नवमी'),
    ],
  };
}
