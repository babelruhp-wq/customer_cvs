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

  const CvFilters({
    this.religion = ReligionFilter.all,
    this.experience = ExperienceFilter.all,
  });

  CvFilters copyWith({
    ReligionFilter? religion,
    ExperienceFilter? experience,
  }) {
    return CvFilters(
      religion: religion ?? this.religion,
      experience: experience ?? this.experience,
    );
  }

  bool get isDefault =>
      religion == ReligionFilter.all && experience == ExperienceFilter.all;

  @override
  List<Object?> get props => [
        religion,
        experience,
      ];
}
