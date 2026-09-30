import '../models/candidate_cv_model.dart';
import '../models/country_model.dart';
import '../models/cv_catalog_type.dart';
import '../models/cv_filters.dart';
import '../models/paged_result.dart';

abstract class CvCatalogService {
  Future<List<CountryModel>> fetchCountries({
    required CvCatalogType catalogType,
  });

  Future<PagedResult<CandidateCvModel>> fetchCvs({
    required String countryId,
    required CvFilters filters,
    required int page,
    required int pageSize,
  });

  Future<List<int>> fetchCvPdf(String cvId);

  void clearCountryCache(String countryId);
}
