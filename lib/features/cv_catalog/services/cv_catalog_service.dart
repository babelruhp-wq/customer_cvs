import '../models/candidate_cv_model.dart';
import '../models/country_model.dart';
import '../models/cv_filters.dart';
import '../models/paged_result.dart';

abstract class CvCatalogService {
  Future<List<CountryModel>> fetchCountries();

  Future<PagedResult<CandidateCvModel>> fetchCvs({
    required String countryId,
    required CvFilters filters,
    required int page,
    required int pageSize,
  });

  /// Loads the PDF file as bytes instead of letting the PDF widget request
  /// the endpoint directly. This is the same flow used in the employee panel
  /// and gives us full control over loading/error states on Flutter Web.
  Future<List<int>> fetchCvPdf(String cvId);

  void clearCountryCache(String countryId);
}
