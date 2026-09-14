import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../cubit/cv_catalog_cubit.dart';
import '../cubit/cv_catalog_state.dart';
import '../widgets/shared/app_header.dart';
import '../widgets/countries/countries_error_state.dart';
import '../widgets/countries/countries_footer.dart';
import '../widgets/countries/countries_help_section.dart';
import '../widgets/countries/countries_hero_section.dart';
import '../widgets/countries/countries_section_header.dart';
import '../widgets/countries/countries_trust_strip.dart';
import '../widgets/countries/country_card.dart';
import 'country_cvs_screen.dart';

class CountriesScreen extends StatelessWidget {
  const CountriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const AppHeader(),

          Expanded(
            child: BlocBuilder<CvCatalogCubit, CvCatalogState>(
              builder: (context, state) {
                if (state.countriesStatus == LoadStatus.loading &&
                    state.countries.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.countriesStatus == LoadStatus.failure &&
                    state.countries.isEmpty) {
                  return CountriesErrorState(
                    message: state.error ?? 'تعذر تحميل الدول',
                    onRetry: context.read<CvCatalogCubit>().loadCountries,
                  );
                }

                return RefreshIndicator(
                  onRefresh: context.read<CvCatalogCubit>().loadCountries,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // ==================================================
                      // HERO
                      // ==================================================
                      SliverToBoxAdapter(
                        child: CountriesHeroSection(
                          countriesCount: state.countries.length,
                        ),
                      ),

                      // ==================================================
                      // COUNTRIES HEADER
                      // ==================================================
                      const SliverToBoxAdapter(
                        child: CountriesSectionHeader(),
                      ),

                      // ==================================================
                      // COUNTRIES GRID
                      // ==================================================
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 44),
                        sliver: SliverLayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.crossAxisExtent;

                            final maxExtent = width < 580 ? width : 385.0;
                            return SliverGrid(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final country = state.countries[index];

                                return CountryCard(
                                  country: country,
                                  onTap: () {
                                    context
                                        .read<CvCatalogCubit>()
                                        .selectCountry(country);

                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) =>
                                            const CountryCvsScreen(),
                                      ),
                                    );
                                  },
                                );
                              }, childCount: state.countries.length),
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: maxExtent,
                                    mainAxisExtent: 415,
                                    mainAxisSpacing: 26,
                                    crossAxisSpacing: 26,
                                  ),
                            );
                          },
                        ),
                      ),

                      // ==================================================
                      // HELP
                      // ==================================================
                      const SliverToBoxAdapter(child: CountriesHelpSection()),

                      // ==================================================
                      // TRUST
                      // ==================================================
                      const SliverToBoxAdapter(child: CountriesTrustStrip()),

                      // ==================================================
                      // FOOTER
                      // ==================================================
                      const SliverToBoxAdapter(child: CountriesFooter()),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

