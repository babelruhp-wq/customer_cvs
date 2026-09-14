import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../cubit/cv_catalog_cubit.dart';
import '../cubit/cv_catalog_state.dart';
import '../widgets/shared/app_header.dart';
import '../widgets/cvs/candidate_card.dart';
import '../widgets/cvs/country_banner.dart';
import '../widgets/cvs/country_cvs_feedback.dart';
import '../widgets/cvs/cv_filters_panel.dart';
import '../widgets/cvs/cv_pagination.dart';
import '../widgets/cvs/passport_search_field.dart';
import '../widgets/cvs/results_toolbar.dart';

class CountryCvsScreen extends StatelessWidget {
  const CountryCvsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final pagePadding =
    screenWidth >
        AppLayout.maxContentWidth + 48
        ? (screenWidth -
        AppLayout.maxContentWidth) /
        2
        : screenWidth < 600
        ? 16.0
        : 24.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const AppHeader(
            showBack: true,
          ),

          Expanded(
            child: BlocBuilder<
                CvCatalogCubit,
                CvCatalogState>(
              builder: (
                  context,
                  state,
                  ) {
                final country =
                    state.selectedCountry;

                if (country == null) {
                  return NoCountrySelected(
                    onBack: () =>
                        Navigator.maybePop(
                          context,
                        ),
                  );
                }

                return CustomScrollView(
                  physics:
                  const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // ========================================
                    // COUNTRY BANNER
                    // ========================================

                    SliverToBoxAdapter(
                      child: CountryBanner(
                        isoCode:
                        country.flagCode,
                        name:
                        country.countryName,
                        totalCount:
                        state.totalCount,
                      ),
                    ),

                    // ========================================
                    // FILTERS
                    // ========================================

                    SliverPadding(
                      padding:
                      EdgeInsets.fromLTRB(
                        pagePadding,
                        24,
                        pagePadding,
                        0,
                      ),
                      sliver:
                      const SliverToBoxAdapter(
                        child:
                        CvFiltersPanel(),
                      ),
                    ),

                    // ========================================
                    // PASSPORT SEARCH
                    // ========================================

                    SliverPadding(
                      padding:
                      EdgeInsets.fromLTRB(
                        pagePadding,
                        14,
                        pagePadding,
                        0,
                      ),
                      sliver:
                      SliverToBoxAdapter(
                        child:
                        PassportSearchField(
                          value: state.filters
                              .passportNumber,
                        ),
                      ),
                    ),

                    // ========================================
                    // RESULTS TOOLBAR
                    // ========================================

                    SliverPadding(
                      padding:
                      EdgeInsets.fromLTRB(
                        pagePadding,
                        18,
                        pagePadding,
                        14,
                      ),
                      sliver:
                      SliverToBoxAdapter(
                        child:
                        ResultsToolbar(
                          state: state,
                        ),
                      ),
                    ),

                    // ========================================
                    // LOADING
                    // ========================================

                    if (state.cvsStatus ==
                        LoadStatus
                            .loading &&
                        state.cvs.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child:
                          CircularProgressIndicator(),
                        ),
                      )

                    // ========================================
                    // ERROR
                    // ========================================

                    else if (state
                        .cvsStatus ==
                        LoadStatus
                            .failure &&
                        state.cvs.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: CvErrorState(
                          message: state.error ??
                              'تعذر تحميل السير الذاتية',
                        ),
                      )

                    // ========================================
                    // EMPTY
                    // ========================================

                    else if (state
                          .cvs.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: CvEmptyState(
                            hasPassportSearch:
                            state
                                .filters
                                .passportNumber
                                .trim()
                                .isNotEmpty,
                          ),
                        )

                      // ========================================
                      // CV GRID
                      // ========================================

                      else
                        SliverPadding(
                          padding:
                          EdgeInsets.fromLTRB(
                            pagePadding,
                            0,
                            pagePadding,
                            28,
                          ),
                          sliver: SliverGrid(
                            delegate:
                            SliverChildBuilderDelegate(
                                  (
                                  context,
                                  index,
                                  ) {
                                final candidate =
                                state.cvs[
                                index];

                                return CandidateCard(
                                  key: ValueKey(
                                    candidate.id,
                                  ),
                                  candidate:
                                  candidate,
                                );
                              },
                              childCount:
                              state.cvs.length,
                            ),
                            gridDelegate:
                            SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent:
                              700,
                              mainAxisExtent:
                              screenWidth <
                                  700
                                  ? 790
                                  : 870,
                              crossAxisSpacing:
                              20,
                              mainAxisSpacing:
                              20,
                            ),
                          ),
                        ),

                    // ========================================
                    // PAGINATION
                    // ========================================

                    SliverPadding(
                      padding:
                      EdgeInsets.symmetric(
                        horizontal:
                        pagePadding,
                      ),
                      sliver:
                      SliverToBoxAdapter(
                        child: CvPagination(
                          state: state,
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child:
                      SizedBox(height: 46),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


