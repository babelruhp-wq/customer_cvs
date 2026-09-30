import 'package:equatable/equatable.dart';

import '../models/candidate_cv_model.dart';
import '../models/country_model.dart';
import '../models/cv_catalog_type.dart';
import '../models/cv_filters.dart';

enum LoadStatus {
  initial,
  loading,
  success,
  failure,
}

class CvCatalogState extends Equatable {
  final CvCatalogType catalogType;

  final LoadStatus countriesStatus;
  final LoadStatus cvsStatus;

  final List<CountryModel> countries;
  final CountryModel? selectedCountry;
  final List<CandidateCvModel> cvs;

  final CvFilters filters;

  final int page;
  final int pageSize;

  final int totalCount;
  final int totalPages;

  final String? error;

  const CvCatalogState({
    this.catalogType = CvCatalogType.recruitment,
    this.countriesStatus = LoadStatus.initial,
    this.cvsStatus = LoadStatus.initial,
    this.countries = const [],
    this.selectedCountry,
    this.cvs = const [],
    this.filters = const CvFilters(),
    this.page = 1,
    this.pageSize = 6,
    this.totalCount = 0,
    this.totalPages = 1,
    this.error,
  });

  CvCatalogState copyWith({
    CvCatalogType? catalogType,
    LoadStatus? countriesStatus,
    LoadStatus? cvsStatus,
    List<CountryModel>? countries,
    CountryModel? selectedCountry,
    bool clearSelectedCountry = false,
    List<CandidateCvModel>? cvs,
    CvFilters? filters,
    int? page,
    int? pageSize,
    int? totalCount,
    int? totalPages,
    String? error,
    bool clearError = false,
  }) {
    return CvCatalogState(
      catalogType: catalogType ?? this.catalogType,
      countriesStatus:
          countriesStatus ?? this.countriesStatus,
      cvsStatus: cvsStatus ?? this.cvsStatus,
      countries: countries ?? this.countries,
      selectedCountry: clearSelectedCountry
          ? null
          : selectedCountry ?? this.selectedCountry,
      cvs: cvs ?? this.cvs,
      filters: filters ?? this.filters,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        catalogType,
        countriesStatus,
        cvsStatus,
        countries,
        selectedCountry,
        cvs,
        filters,
        page,
        pageSize,
        totalCount,
        totalPages,
        error,
      ];
}
