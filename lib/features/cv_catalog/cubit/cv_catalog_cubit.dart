import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/country_model.dart';
import '../models/cv_filters.dart';
import '../repository/cv_catalog_repository.dart';
import 'cv_catalog_state.dart';

class CvCatalogCubit extends Cubit<CvCatalogState> {
  final CvCatalogRepository repository;

  /// Prevents an older request from replacing a newer result.
  int _requestToken = 0;

  CvCatalogCubit(
      this.repository,
      ) : super(
    const CvCatalogState(),
  );

  // =========================================================
  // COUNTRIES
  // =========================================================

  Future<void> loadCountries() async {
    emit(
      state.copyWith(
        countriesStatus: LoadStatus.loading,
        clearError: true,
      ),
    );

    try {
      final countries =
      await repository.getCountries();

      if (isClosed) return;

      emit(
        state.copyWith(
          countriesStatus: LoadStatus.success,
          countries: countries,
          clearError: true,
        ),
      );
    } catch (_) {
      if (isClosed) return;

      emit(
        state.copyWith(
          countriesStatus: LoadStatus.failure,
          error:
          'تعذر تحميل الدول حاليًا. حاول مرة أخرى.',
        ),
      );
    }
  }

  // =========================================================
  // SELECT COUNTRY
  // =========================================================

  void selectCountry(
      CountryModel country,
      ) {
    emit(
      state.copyWith(
        selectedCountry: country,
        filters: const CvFilters(),
        page: 1,
        cvs: const [],
        totalCount: 0,
        totalPages: 1,
        clearError: true,
      ),
    );

    loadCvs();
  }

  // =========================================================
  // LOAD CVS
  // =========================================================

  Future<void> loadCvs({
    bool showLoader = true,
    bool refresh = false,
  }) async {
    final country =
        state.selectedCountry;

    if (country == null) {
      return;
    }

    final token =
    ++_requestToken;

    if (refresh) {
      repository.clearCountryCache(
        country.id,
      );
    }

    emit(
      state.copyWith(
        cvsStatus: showLoader
            ? LoadStatus.loading
            : state.cvsStatus,
        clearError: true,
      ),
    );

    try {
      final result =
      await repository.getCvs(
        countryId: country.id,
        filters: state.filters,
        page: state.page,
        pageSize: state.pageSize,
      );

      if (token != _requestToken ||
          isClosed) {
        return;
      }

      emit(
        state.copyWith(
          cvsStatus: LoadStatus.success,
          cvs: result.items,
          page: result.page,
          totalCount:
          result.totalCount,
          totalPages:
          result.totalPages < 1
              ? 1
              : result.totalPages,
          clearError: true,
        ),
      );
    } catch (_) {
      if (token != _requestToken ||
          isClosed) {
        return;
      }

      emit(
        state.copyWith(
          cvsStatus: LoadStatus.failure,
          error:
          'تعذر تحميل السير الذاتية حاليًا. حاول مرة أخرى.',
        ),
      );
    }
  }

  // =========================================================
  // PDF
  // =========================================================

  Future<List<int>> getCvPdf(
      String cvId,
      ) {
    return repository.getCvPdf(
      cvId,
    );
  }

  // =========================================================
  // SEARCH BY PASSPORT NUMBER
  // =========================================================

  Future<void> setPassportSearch(
      String value,
      ) async {
    final passportNumber =
    value
        .trim()
        .toUpperCase();

    if (passportNumber ==
        state.filters.passportNumber) {
      return;
    }

    emit(
      state.copyWith(
        filters:
        state.filters.copyWith(
          passportNumber:
          passportNumber,
        ),
        page: 1,
      ),
    );

    await loadCvs(
      showLoader: false,
    );
  }

  // =========================================================
  // RELIGION
  // =========================================================

  Future<void> setReligion(
      ReligionFilter value,
      ) async {
    if (value ==
        state.filters.religion) {
      return;
    }

    emit(
      state.copyWith(
        filters:
        state.filters.copyWith(
          religion: value,
        ),
        page: 1,
      ),
    );

    await loadCvs(
      showLoader: false,
    );
  }

  // =========================================================
  // EXPERIENCE
  // =========================================================

  Future<void> setExperience(
      ExperienceFilter value,
      ) async {
    if (value ==
        state.filters.experience) {
      return;
    }

    emit(
      state.copyWith(
        filters:
        state.filters.copyWith(
          experience: value,
        ),
        page: 1,
      ),
    );

    await loadCvs(
      showLoader: false,
    );
  }

  // =========================================================
  // RESET
  // =========================================================

  Future<void> resetFilters() async {
    emit(
      state.copyWith(
        filters:
        const CvFilters(),
        page: 1,
      ),
    );

    await loadCvs(
      showLoader: false,
    );
  }

  // =========================================================
  // PAGINATION
  // =========================================================

  Future<void> setPage(
      int page,
      ) async {
    final maxPage =
    state.totalPages < 1
        ? 1
        : state.totalPages;

    final safePage =
    page
        .clamp(
      1,
      maxPage,
    )
        .toInt();

    if (safePage ==
        state.page) {
      return;
    }

    emit(
      state.copyWith(
        page: safePage,
      ),
    );

    await loadCvs(
      showLoader: false,
    );
  }

  @override
  Future<void> close() {
    _requestToken++;

    return super.close();
  }
}