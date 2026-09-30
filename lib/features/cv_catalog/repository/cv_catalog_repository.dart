import 'package:dio/dio.dart';

import '../models/candidate_cv_model.dart';
import '../models/country_model.dart';
import '../models/cv_catalog_type.dart';
import '../models/cv_filters.dart';
import '../models/paged_result.dart';
import '../services/cv_catalog_service.dart';
import '../services/dio_cv_catalog_service.dart';

class CvCatalogRepository {
  final CvCatalogService service;

  CvCatalogRepository(this.service);

  factory CvCatalogRepository.backend({
    required String baseUrl,
    Map<String, dynamic>? defaultHeaders,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
        headers: defaultHeaders,
      ),
    );

    return CvCatalogRepository(
      DioCvCatalogService(
        dio: dio,
      ),
    );
  }

  Future<List<CountryModel>> getCountries({
    required CvCatalogType catalogType,
  }) {
    return service.fetchCountries(
      catalogType: catalogType,
    );
  }

  Future<PagedResult<CandidateCvModel>> getCvs({
    required String countryId,
    required CvFilters filters,
    required int page,
    required int pageSize,
  }) {
    return service.fetchCvs(
      countryId: countryId,
      filters: filters,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<List<int>> getCvPdf(
    String cvId,
  ) {
    return service.fetchCvPdf(
      cvId,
    );
  }

  void clearCountryCache(
    String countryId,
  ) {
    service.clearCountryCache(
      countryId,
    );
  }
}
