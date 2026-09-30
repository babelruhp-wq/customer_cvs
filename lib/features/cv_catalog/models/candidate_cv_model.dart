import 'package:equatable/equatable.dart';

class CandidateCvModel extends Equatable {
  final String id;

  final String passportNumber;
  final bool isExperienced;
  final bool isMuslim;
  final num salary;

  /// Used by service-transfer CVs.
  /// The recruitment flow simply ignores this field.
  final num priceForTransfer;

  const CandidateCvModel({
    required this.id,
    required this.passportNumber,
    required this.isExperienced,
    required this.isMuslim,
    required this.salary,
    required this.priceForTransfer,
  });

  factory CandidateCvModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CandidateCvModel(
      id: _string(
        json['id'],
      ),
      passportNumber: _string(
        json['passportnumber'] ??
            json['passportNumber'],
      ).toUpperCase(),
      isExperienced: _asBool(
        json['isExperienced'],
      ),
      isMuslim: _asBool(
        json['isMuslim'],
      ),
      salary: _asNum(
        json['salary'],
      ),
      priceForTransfer: _asNum(
        json['priceForTransfer'] ??
            json['transferPrice'] ??
            json['price'],
      ),
    );
  }

  String get religionLabel =>
      isMuslim ? 'مسلمة' : 'غير مسلمة';

  String get experienceLabel =>
      isExperienced
          ? 'سبق لها العمل'
          : 'أول مرة';

  String get passportLabel =>
      passportNumber.isEmpty
          ? 'غير متوفر'
          : passportNumber;

  static String _string(
    dynamic value,
  ) {
    return value?.toString().trim() ?? '';
  }

  static bool _asBool(
    dynamic value,
  ) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final text = value
        ?.toString()
        .trim()
        .toLowerCase();

    return text == 'true' ||
        text == '1';
  }

  static num _asNum(
    dynamic value,
  ) {
    if (value is num) {
      return value;
    }

    return num.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  @override
  List<Object?> get props => [
        id,
        passportNumber,
        isExperienced,
        isMuslim,
        salary,
        priceForTransfer,
      ];
}
