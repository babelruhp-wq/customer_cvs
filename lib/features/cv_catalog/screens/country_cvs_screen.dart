import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../cubit/cv_catalog_cubit.dart';
import '../cubit/cv_catalog_state.dart';
import '../widgets/app_header.dart';
import '../widgets/candidate_card.dart';
import '../widgets/cv_filters_panel.dart';

class CountryCvsScreen extends StatelessWidget {
  const CountryCvsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final pagePadding = screenWidth > AppLayout.maxContentWidth + 48
        ? (screenWidth - AppLayout.maxContentWidth) / 2
        : screenWidth < 600
            ? 16.0
            : 24.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const AppHeader(showBack: true),
          Expanded(
            child: BlocBuilder<CvCatalogCubit, CvCatalogState>(
              builder: (context, state) {
                final country = state.selectedCountry;

                if (country == null) {
                  return _NoCountrySelected(
                    onBack: () => Navigator.maybePop(context),
                  );
                }

                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: _CountryBanner(
                        isoCode: country.flagCode,
                        name: country.countryName,
                        totalCount: state.totalCount,
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        pagePadding,
                        24,
                        pagePadding,
                        0,
                      ),
                      sliver: const SliverToBoxAdapter(
                        child: CvFiltersPanel(),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        pagePadding,
                        18,
                        pagePadding,
                        14,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _ResultsToolbar(state: state),
                      ),
                    ),
                    if (state.cvsStatus == LoadStatus.loading &&
                        state.cvs.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state.cvsStatus == LoadStatus.failure &&
                        state.cvs.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _CvError(
                          message: state.error ?? 'تعذر تحميل السير الذاتية',
                        ),
                      )
                    else if (state.cvs.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyState(),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          pagePadding,
                          0,
                          pagePadding,
                          28,
                        ),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final candidate = state.cvs[index];
                              return CandidateCard(
                                key: ValueKey(candidate.id),
                                candidate: candidate,
                              );
                            },
                            childCount: state.cvs.length,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 700,
                            mainAxisExtent: screenWidth < 700 ? 790 : 870,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                        ),
                      ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: pagePadding),
                      sliver: SliverToBoxAdapter(
                        child: _Pagination(state: state),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 46)),
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

class _CountryBanner extends StatelessWidget {
  final String isoCode;
  final String name;
  final int totalCount;

  const _CountryBanner({
    required this.isoCode,
    required this.name,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppGradients.hero),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 540;

                final flag = Container(
                  width: compact ? 76 : 92,
                  height: compact ? 58 : 70,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppShadows.card,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    child: CountryFlag.fromCountryCode(isoCode),
                  ),
                );

                final content = Column(
                  crossAxisAlignment: compact
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      textAlign: compact ? TextAlign.center : TextAlign.start,
                      style: GoogleFonts.cairo(
                        color: AppColors.textOnPrimary,
                        fontSize: compact ? 28 : 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: .09),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(
                          color: AppColors.surface.withValues(alpha: .12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.description_outlined,
                            color: AppColors.secondary,
                            size: 15,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$totalCount نتيجة متاحة',
                            style: GoogleFonts.cairo(
                              color: AppColors.heroTextSoft,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );

                if (compact) {
                  return Column(
                    children: [
                      flag,
                      const SizedBox(height: 14),
                      content,
                    ],
                  );
                }

                return Row(
                  children: [
                    flag,
                    const SizedBox(width: 18),
                    Expanded(child: content),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultsToolbar extends StatelessWidget {
  final CvCatalogState state;

  const _ResultsToolbar({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            state.totalCount == 1
                ? 'سيرة ذاتية واحدة مطابقة'
                : '${state.totalCount} سيرة ذاتية مطابقة',
            style: GoogleFonts.cairo(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: state.cvsStatus == LoadStatus.loading
              ? null
              : () => context.read<CvCatalogCubit>().loadCvs(refresh: true),
          icon: const Icon(Icons.refresh_rounded, size: 17),
          label: Text(
            'تحديث',
            style: GoogleFonts.cairo(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _Pagination extends StatelessWidget {
  final CvCatalogState state;

  const _Pagination({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.totalPages <= 1) return const SizedBox.shrink();

    final cubit = context.read<CvCatalogCubit>();
    final start = (state.page - 2).clamp(1, state.totalPages).toInt();
    final end = (state.page + 2).clamp(1, state.totalPages).toInt();

    return Center(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.card,
        ),
        child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                onPressed: state.page > 1
                    ? () => cubit.setPage(state.page - 1)
                    : null,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ),
            for (int page = start; page <= end; page++)
              SizedBox(
                width: 40,
                height: 40,
                child: page == state.page
                    ? FilledButton(
                        onPressed: null,
                        style: AppButtonStyles.paginationSelected,
                        child: Text('$page'),
                      )
                    : OutlinedButton(
                        onPressed: () => cubit.setPage(page),
                        style: AppButtonStyles.paginationNormal,
                        child: Text('$page'),
                      ),
              ),
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                onPressed: state.page < state.totalPages
                    ? () => cubit.setPage(state.page + 1)
                    : null,
                icon: const Icon(Icons.chevron_left_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 430),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(28),
        decoration: AppDecorations.sectionCard,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.search_off_rounded,
                size: 31,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'لا توجد سير مطابقة',
              style: GoogleFonts.cairo(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'جرّب تغيير الديانة أو الخبرة لعرض نتائج أخرى.',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                color: AppColors.textSecondary,
                fontSize: 12.5,
                height: 1.7,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: context.read<CvCatalogCubit>().resetFilters,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                'إعادة ضبط الفلاتر',
                style: GoogleFonts.cairo(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CvError extends StatelessWidget {
  final String message;

  const _CvError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(28),
        decoration: AppDecorations.sectionCard,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 52,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                color: AppColors.textPrimary,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () => context.read<CvCatalogCubit>().loadCvs(
                    refresh: true,
                  ),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                'إعادة المحاولة',
                style: GoogleFonts.cairo(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoCountrySelected extends StatelessWidget {
  final VoidCallback onBack;

  const _NoCountrySelected({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.public_off_rounded,
            size: 48,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 12),
          Text(
            'لم يتم اختيار دولة',
            style: GoogleFonts.cairo(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(
              'رجوع',
              style: GoogleFonts.cairo(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
