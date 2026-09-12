import 'package:equatable/equatable.dart';

class CandidateCvModel extends Equatable {
  /// Internal identifier only. Never displayed to the customer.
  /// It is used only to request /CVsViewer/GetCVPdfInline/{cvId}.
  final String id;

  final bool isExperienced;
  final bool isMuslim;
  final num salary;

  const CandidateCvModel({
    required this.id,
    required this.isExperienced,
    required this.isMuslim,
    required this.salary,
  });

  factory CandidateCvModel.fromJson(Map<String, dynamic> json) {
    return CandidateCvModel(
      id: _string(json['id']),
      isExperienced: _asBool(json['isExperienced']),
      isMuslim: _asBool(json['isMuslim']),
      salary: _asNum(json['salary']),
    );
  }

  String get religionLabel => isMuslim ? 'مسلمة' : 'غير مسلمة';

  String get experienceLabel => isExperienced ? 'سبق لها العمل' : 'أول مرة';

  static String _string(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    return value?.toString().toLowerCase() == 'true';
  }

  static num _asNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }

  @override
  List<Object?> get props => [
        id,
        isExperienced,
        isMuslim,
        salary,
      ];
}
