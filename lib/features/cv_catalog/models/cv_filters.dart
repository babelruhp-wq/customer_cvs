import 'package:equatable/equatable.dart';

enum ReligionFilter {
  all,
  muslim,
  nonMuslim,
}

enum ExperienceFilter {
  all,
  experienced,
  firstTime,
}

class CvFilters extends Equatable {
  final ReligionFilter religion;
  final ExperienceFilter experience;
  final String passportNumber;

  const CvFilters({
    this.religion = ReligionFilter.all,
    this.experience = ExperienceFilter.all,
    this.passportNumber = '',
  });

  CvFilters copyWith({
    ReligionFilter? religion,
    ExperienceFilter? experience,
    String? passportNumber,
  }) {
    return CvFilters(
      religion: religion ?? this.religion,
      experience: experience ?? this.experience,
      passportNumber:
      passportNumber ?? this.passportNumber,
    );
  }

  bool get isDefault =>
      religion == ReligionFilter.all &&
          experience == ExperienceFilter.all &&
          passportNumber.trim().isEmpty;

  @override
  List<Object?> get props => [
    religion,
    experience,
    passportNumber,
  ];
}