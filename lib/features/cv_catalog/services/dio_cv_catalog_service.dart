import 'package:dio/dio.dart';

import '../models/candidate_cv_model.dart';
import '../models/country_model.dart';
import '../models/cv_filters.dart';
import '../models/paged_result.dart';
import 'cv_catalog_service.dart';

class DioCvCatalogService implements CvCatalogService {
  static const String countriesPath =
      '/CVsViewer/GetAllCVsViewerCountries';

  static const String countryCvsPath =
      '/CVsViewer/GetViewerCVsByCountryId';

  static const String inlinePdfPath =
      '/CVsViewer/GetCVPdfInline';

  final Dio dio;

  /// The endpoint returns the full country CV list.
  ///
  /// We cache the complete list and apply:
  /// - Passport number search
  /// - Religion filter
  /// - Experience filter
  /// - Pagination
  ///
  /// locally for a faster UX.
  final Map<String, List<CandidateCvModel>>
  _countryCache = {};

  DioCvCatalogService({
    required this.dio,
  });

  // =========================================================
  // COUNTRIES
  // =========================================================

  @override
  Future<List<CountryModel>>
  fetchCountries() async {
    final response =
    await dio.get(
      countriesPath,
    );

    final raw = response.data;

    if (raw is! List) {
      return const [];
    }

    return raw
        .whereType<Map>()
        .map(
          (item) =>
          CountryModel.fromJson(
            Map<String, dynamic>.from(
              item,
            ),
          ),
    )
        .where(
          (country) =>
      country.id.isNotEmpty,
    )
        .toList(
      growable: false,
    );
  }

  // =========================================================
  // CVS
  // =========================================================

  @override
  Future<PagedResult<CandidateCvModel>>
  fetchCvs({
    required String countryId,
    required CvFilters filters,
    required int page,
    required int pageSize,
  }) async {
    final allItems =
    await _loadCountryCvs(
      countryId,
    );

    // =======================================================
    // NORMALIZE PASSPORT SEARCH
    // =======================================================

    final passportQuery =
    filters.passportNumber
        .trim()
        .toUpperCase();

    // =======================================================
    // APPLY ALL FILTERS BEFORE PAGINATION
    // =======================================================

    final filtered =
    allItems.where(
          (item) {
        // ---------------------------------------------------
        // PASSPORT NUMBER
        // ---------------------------------------------------

        final itemPassportNumber =
        item.passportNumber
            .trim()
            .toUpperCase();

        final passportMatches =
            passportQuery.isEmpty ||
                itemPassportNumber.contains(
                  passportQuery,
                );

        // ---------------------------------------------------
        // RELIGION
        // ---------------------------------------------------

        final religionMatches =
        switch (filters.religion) {
          ReligionFilter.all => true,
          ReligionFilter.muslim =>
          item.isMuslim,
          ReligionFilter.nonMuslim =>
          !item.isMuslim,
        };

        // ---------------------------------------------------
        // EXPERIENCE
        // ---------------------------------------------------

        final experienceMatches =
        switch (filters.experience) {
          ExperienceFilter.all => true,
          ExperienceFilter.experienced =>
          item.isExperienced,
          ExperienceFilter.firstTime =>
          !item.isExperienced,
        };

        // ---------------------------------------------------
        // FINAL RESULT
        // ---------------------------------------------------

        return passportMatches &&
            religionMatches &&
            experienceMatches;
      },
    ).toList(
      growable: false,
    );

    // =======================================================
    // TOTALS AFTER FILTERING
    // =======================================================

    final totalCount =
        filtered.length;

    final totalPages =
    totalCount == 0
        ? 1
        : (totalCount / pageSize)
        .ceil();

    final safePage =
    page
        .clamp(
      1,
      totalPages,
    )
        .toInt();

    // =======================================================
    // PAGINATION
    // =======================================================

    final start =
        (safePage - 1) *
            pageSize;

    final end =
    (start + pageSize)
        .clamp(
      0,
      totalCount,
    )
        .toInt();

    final items =
    start >= totalCount
        ? const <
        CandidateCvModel>[]
        : filtered.sublist(
      start,
      end,
    );

    // =======================================================
    // RESULT
    // =======================================================

    return PagedResult<
        CandidateCvModel>(
      items: items,
      page: safePage,
      pageSize: pageSize,
      totalCount: totalCount,
      totalPages: totalPages,
    );
  }

  // =========================================================
  // LOAD COUNTRY CVS
  // =========================================================

  Future<List<CandidateCvModel>>
  _loadCountryCvs(
      String countryId,
      ) async {
    final cached =
    _countryCache[countryId];

    if (cached != null) {
      return cached;
    }

    final response =
    await dio.get(
      '$countryCvsPath/$countryId',
    );

    final raw =
        response.data;

    if (raw is! List) {
      _countryCache[
      countryId] = const [];

      return const [];
    }

    final items =
    raw
        .whereType<Map>()
        .map(
          (item) =>
          CandidateCvModel
              .fromJson(
            Map<String,
                dynamic>.from(
              item,
            ),
          ),
    )
        .where(
          (item) =>
      item.id.isNotEmpty,
    )
        .toList(
      growable: false,
    );

    _countryCache[
    countryId] = items;

    return items;
  }

  // =========================================================
  // PDF
  // =========================================================

  @override
  Future<List<int>> fetchCvPdf(
      String cvId,
      ) async {
    final id =
    cvId.trim();

    if (id.isEmpty) {
      throw Exception(
        'معرّف السيرة الذاتية غير صالح.',
      );
    }

    final response =
    await dio.get<dynamic>(
      '$inlinePdfPath/$id',
      options: Options(
        responseType:
        ResponseType.bytes,
        headers: const {
          'Accept':
          'application/pdf',
        },
      ),
    );

    final data =
        response.data;

    if (data is List &&
        data.isNotEmpty) {
      final bytes = data
          .map(
            (e) =>
            (e as num)
                .toInt(),
      )
          .toList(
        growable: false,
      );

      // %PDF signature:
      // 25 50 44 46
      final isPdf =
          bytes.length >= 4 &&
              bytes[0] ==
                  0x25 &&
              bytes[1] ==
                  0x50 &&
              bytes[2] ==
                  0x44 &&
              bytes[3] ==
                  0x46;

      if (!isPdf) {
        throw Exception(
          'استجابة ملف السيرة الذاتية ليست PDF صالحاً.',
        );
      }

      return bytes;
    }

    throw Exception(
      'ملف السيرة الذاتية فارغ أو غير صالح.',
    );
  }

  // =========================================================
  // CACHE
  // =========================================================

  @override
  void clearCountryCache(
      String countryId,
      ) {
    _countryCache.remove(
      countryId,
    );
  }
}