import 'package:equatable/equatable.dart';

class CountryModel extends Equatable {
  final String id;
  final String countryName;
  final String flagCode;
  final num price;
  final bool hasRibbon;
  final String ribbon;
  final int cVsCount;

  const CountryModel({
    required this.id,
    required this.countryName,
    required this.flagCode,
    required this.price,
    required this.hasRibbon,
    required this.ribbon,
    required this.cVsCount,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: _string(json['id']),
      countryName: _string(json['countryName']),
      flagCode: _string(json['flagCode']).toUpperCase(),
      price: _asNum(json['price']),
      hasRibbon: _asBool(json['hasRibbon']),
      ribbon: _string(json['ribbon']),
      cVsCount: _asInt(json['cVsCount']),
    );
  }

  bool get showRibbon =>
      hasRibbon && ribbon.trim().isNotEmpty;

  // Compatibility getters used by the current UI structure.
  String get nameAr => countryName;
  String get isoCode => flagCode;
  num get recruitmentPrice => price;
  String? get offerName => showRibbon ? ribbon : null;

  static String _string(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  static num _asNum(dynamic value) {
    if (value is num) return value;

    return num.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static bool _asBool(dynamic value) {
    if (value is bool) return value;

    return value
        ?.toString()
        .toLowerCase() ==
        'true';
  }

  @override
  List<Object?> get props => [
    id,
    countryName,
    flagCode,
    price,
    hasRibbon,
    ribbon,
    cVsCount,
  ];
}