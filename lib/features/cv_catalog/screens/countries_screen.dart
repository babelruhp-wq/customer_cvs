import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../cubit/cv_catalog_cubit.dart';
import '../cubit/cv_catalog_state.dart';
import '../widgets/app_header.dart';
import '../widgets/country_card.dart';
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.countriesStatus == LoadStatus.failure &&
                    state.countries.isEmpty) {
                  return _ErrorState(
                    message: state.error ?? 'تعذر تحميل الدول',
                    onRetry:
                    context.read<CvCatalogCubit>().loadCountries,
                  );
                }

                return RefreshIndicator(
                  onRefresh:
                  context.read<CvCatalogCubit>().loadCountries,
                  child: CustomScrollView(
                    physics:
                    const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // ==================================================
                      // HERO
                      // ==================================================

                      SliverToBoxAdapter(
                        child: _HeroSection(
                          countriesCount:
                          state.countries.length,
                        ),
                      ),

                      // ==================================================
                      // COUNTRIES HEADER
                      // ==================================================

                      const SliverToBoxAdapter(
                        child: _CountriesSectionHeader(),
                      ),

                      // ==================================================
                      // COUNTRIES GRID
                      // ==================================================

                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          24,
                          0,
                          24,
                          44,
                        ),
                        sliver: SliverLayoutBuilder(
                          builder: (context, constraints) {
                            final width =
                                constraints.crossAxisExtent;

                            final maxExtent =
                            width < 580
                                ? width
                                : 325.0;

                            return SliverGrid(
                              delegate:
                              SliverChildBuilderDelegate(
                                    (context, index) {
                                  final country =
                                  state.countries[index];

                                  return CountryCard(
                                    country: country,
                                    onTap: () {
                                      context
                                          .read<CvCatalogCubit>()
                                          .selectCountry(
                                        country,
                                      );

                                      Navigator.of(
                                        context,
                                      ).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) =>
                                          const CountryCvsScreen(),
                                        ),
                                      );
                                    },
                                  );
                                },
                                childCount:
                                state.countries.length,
                              ),
                              gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent:
                                maxExtent,

                                // زودنا ارتفاع الكارد
                                // لاستيعاب عدد السير وحالة الانتظار
                                mainAxisExtent: 345,

                                mainAxisSpacing: 22,
                                crossAxisSpacing: 22,
                              ),
                            );
                          },
                        ),
                      ),

                      // ==================================================
                      // HELP
                      // ==================================================

                      const SliverToBoxAdapter(
                        child: _HelpSection(),
                      ),

                      // ==================================================
                      // TRUST
                      // ==================================================

                      const SliverToBoxAdapter(
                        child: _TrustStrip(),
                      ),

                      // ==================================================
                      // FOOTER
                      // ==================================================

                      const SliverToBoxAdapter(
                        child: _Footer(),
                      ),
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

// ==========================================================
// HERO
// ==========================================================

class _HeroSection extends StatelessWidget {
  final int countriesCount;

  const _HeroSection({
    required this.countriesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF102E5E),
            Color(0xFF0A2348),
            Color(0xFF071A36),
          ],
          stops: [
            0.0,
            .55,
            1.0,
          ],
        ),
      ),

      child: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth:
                AppLayout.maxContentWidth,
              ),
              child: LayoutBuilder(
                builder: (
                    context,
                    constraints,
                    ) {
                  final compact =
                      constraints.maxWidth < 1100;

                  final heroHeight =
                  compact ? 370.0 : 390.0;

                  final logoWidth =
                  compact ? 430.0 : 550.0;

                  final contentWidth =
                  compact ? 560.0 : 690.0;

                  return SizedBox(
                    height: heroHeight,
                    child: Stack(
                      children: [
                        // ==========================================
                        // LOGO AREA
                        // ==========================================

                        Positioned(
                          left:
                          compact ? -15 : 0,
                          top: 15,
                          bottom: 15,
                          width: logoWidth,
                          child:
                          const _HeroWatermarkLogo(),
                        ),

                        // ==========================================
                        // HERO CONTENT
                        // ==========================================

                        Positioned(
                          right: 32,
                          top: 28,
                          bottom: 28,
                          width: contentWidth,
                          child: _HeroContent(
                            countriesCount:
                            countriesCount,
                            compact: compact,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// HERO LOGO
// ==========================================================

class _HeroWatermarkLogo extends StatelessWidget {
  const _HeroWatermarkLogo();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 520,
            height: 350,
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(
                260,
              ),
              gradient: RadialGradient(
                center: const Alignment(
                  0,
                  0.12,
                ),
                radius: .82,
                colors: [
                  AppColors.surface
                      .withValues(
                    alpha: .30,
                  ),
                  AppColors.surface
                      .withValues(
                    alpha: .19,
                  ),
                  AppColors.secondary
                      .withValues(
                    alpha: .045,
                  ),
                  AppColors.surface
                      .withValues(
                    alpha: .035,
                  ),
                  AppColors.transparent,
                ],
                stops: const [
                  0.0,
                  .34,
                  .58,
                  .76,
                  1.0,
                ],
              ),
            ),
          ),

          Opacity(
            opacity: 1,
            child: SizedBox(
              width: 395,
              height: 315,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                filterQuality:
                FilterQuality.high,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// HERO CONTENT
// ==========================================================

class _HeroContent extends StatelessWidget {
  final int countriesCount;
  final bool compact;

  const _HeroContent({
    required this.countriesCount,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
      MainAxisAlignment.center,
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Container(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface
                .withValues(
              alpha: .075,
            ),
            borderRadius:
            BorderRadius.circular(
              AppRadius.pill,
            ),
            border: Border.all(
              color: AppColors.surface
                  .withValues(
                alpha: .12,
              ),
            ),
          ),
          child: Row(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration:
                const BoxDecoration(
                  color:
                  AppColors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'بابل الرياض للاستقدام',
                style: GoogleFonts.cairo(
                  color:
                  AppColors.heroTextSoft,
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 17),

        Text(
          'اختر السيرة المناسبة\nبكل سهولة',
          style: GoogleFonts.cairo(
            color:
            AppColors.textOnPrimary,
            fontSize:
            compact ? 34 : 39,
            height: 1.30,
            fontWeight:
            FontWeight.w900,
          ),
        ),

        const SizedBox(height: 13),

        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth:
            compact ? 540 : 600,
          ),
          child: Text(
            'استعرض السير الذاتية المتاحة حسب الدولة، واستخدم الفلاتر للوصول إلى الاختيار المناسب لك.',
            style: GoogleFonts.cairo(
              color:
              AppColors.heroTextSoft,
              fontSize: 13.5,
              height: 1.9,
              fontWeight:
              FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: 24),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _HeroStat(
              icon:
              Icons.public_rounded,
              value:
              '$countriesCount',
              label: 'دول متاحة',
            ),
            const _HeroStat(
              icon: Icons
                  .picture_as_pdf_outlined,
              value: 'مباشر',
              label: 'عرض السيرة',
            ),
            const _HeroStat(
              icon:
              Icons.tune_rounded,
              value: 'سهل',
              label: 'فلترة سريعة',
            ),
          ],
        ),
      ],
    );
  }
}

// ==========================================================
// HERO STAT
// ==========================================================

class _HeroStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _HeroStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
      const BoxConstraints(
        minWidth: 132,
      ),
      padding:
      const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface
            .withValues(
          alpha: .075,
        ),
        borderRadius:
        BorderRadius.circular(
          AppRadius.md,
        ),
        border: Border.all(
          color: AppColors.surface
              .withValues(
            alpha: .11,
          ),
        ),
      ),
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: AppColors.secondary
                  .withValues(
                alpha: .13,
              ),
              borderRadius:
              BorderRadius.circular(
                AppRadius.sm,
              ),
              border: Border.all(
                color: AppColors.secondary
                    .withValues(
                  alpha: .10,
                ),
              ),
            ),
            alignment:
            Alignment.center,
            child: Icon(
              icon,
              size: 17,
              color:
              AppColors.secondary,
            ),
          ),

          const SizedBox(width: 9),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            mainAxisSize:
            MainAxisSize.min,
            children: [
              Text(
                value,
                style:
                GoogleFonts.cairo(
                  color: AppColors
                      .textOnPrimary,
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w900,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                label,
                style:
                GoogleFonts.cairo(
                  color: AppColors
                      .heroTextSoft,
                  fontSize: 10,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// COUNTRIES SECTION
// ==========================================================

class _CountriesSectionHeader
    extends StatelessWidget {
  const _CountriesSectionHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.fromLTRB(
        24,
        40,
        24,
        24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
          const BoxConstraints(
            maxWidth:
            AppLayout.maxContentWidth,
          ),
          child: Column(
            children: [
              Text(
                'السير الذاتية المتاحة',
                textAlign:
                TextAlign.center,
                style:
                GoogleFonts.cairo(
                  color: AppColors
                      .secondaryDark,
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w900,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'اختر الدولة',
                textAlign:
                TextAlign.center,
                style:
                GoogleFonts.cairo(
                  color:
                  AppColors.primary,
                  fontSize: 29,
                  height: 1.35,
                  fontWeight:
                  FontWeight.w900,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'اختر الدولة لعرض السير الذاتية المتاحة.',
                textAlign:
                TextAlign.center,
                style:
                GoogleFonts.cairo(
                  color: AppColors
                      .textSecondary,
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// HELP
// ==========================================================

class _HelpSection extends StatelessWidget {
  const _HelpSection();

  Future<void> _callOffice() async {
    await launchUrl(
      Uri(
        scheme: 'tel',
        path:
        AppHeader.officePhone,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.fromLTRB(
        24,
        4,
        24,
        42,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
          const BoxConstraints(
            maxWidth:
            AppLayout.maxContentWidth,
          ),
          child: Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 27,
            ),
            decoration: BoxDecoration(
              gradient:
              const LinearGradient(
                begin:
                Alignment.centerRight,
                end:
                Alignment.centerLeft,
                colors: [
                  Color(0xFF102E5E),
                  Color(0xFF071A36),
                ],
              ),
              borderRadius:
              BorderRadius.circular(
                AppRadius.xl,
              ),
              boxShadow:
              AppShadows.card,
              border: Border.all(
                color: AppColors.secondary
                    .withValues(
                  alpha: .12,
                ),
              ),
            ),
            child: LayoutBuilder(
              builder: (
                  context,
                  constraints,
                  ) {
                final desktop =
                    constraints.maxWidth >=
                        720;

                final content = Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      'وجدت السيرة المناسبة؟',
                      style:
                      GoogleFonts.cairo(
                        color: AppColors
                            .textOnPrimary,
                        fontWeight:
                        FontWeight.w900,
                        fontSize: 21,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'تواصل مباشرة مع فريق بابل الرياض للاستقدام لمساعدتك.',
                      style:
                      GoogleFonts.cairo(
                        color: AppColors
                            .heroTextSoft,
                        fontSize: 13,
                        height: 1.7,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),
                  ],
                );

                final button =
                FilledButton.icon(
                  onPressed: _callOffice,
                  style:
                  FilledButton.styleFrom(
                    backgroundColor:
                    AppColors.secondary,
                    foregroundColor:
                    AppColors
                        .textOnSecondary,
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 22,
                      vertical: 15,
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                        AppRadius.md,
                      ),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(
                    Icons.call_rounded,
                    size: 18,
                  ),
                  label: Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      Text(
                        'اتصل بنا',
                        style:
                        GoogleFonts.cairo(
                          fontWeight:
                          FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Directionality(
                        textDirection:
                        TextDirection.ltr,
                        child: Text(
                          AppHeader
                              .officePhone,
                          style:
                          GoogleFonts.cairo(
                            fontWeight:
                            FontWeight
                                .w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                if (desktop) {
                  return Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration:
                        BoxDecoration(
                          color: AppColors
                              .secondary
                              .withValues(
                            alpha: .13,
                          ),
                          borderRadius:
                          BorderRadius
                              .circular(
                            AppRadius.md,
                          ),
                          border:
                          Border.all(
                            color: AppColors
                                .secondary
                                .withValues(
                              alpha: .14,
                            ),
                          ),
                        ),
                        alignment:
                        Alignment.center,
                        child:
                        const Icon(
                          Icons
                              .support_agent_rounded,
                          color: AppColors
                              .secondary,
                          size: 25,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: content,
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      button,
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .stretch,
                  children: [
                    content,
                    const SizedBox(
                      height: 18,
                    ),
                    button,
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

// ==========================================================
// TRUST
// ==========================================================

class _TrustStrip extends StatelessWidget {
  const _TrustStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 28,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
          const BoxConstraints(
            maxWidth:
            AppLayout.maxContentWidth,
          ),
          child: const Wrap(
            alignment:
            WrapAlignment
                .spaceBetween,
            spacing: 30,
            runSpacing: 22,
            children: [
              _TrustItem(
                icon: Icons
                    .verified_user_outlined,
                title: 'بيانات واضحة',
                subtitle:
                'المعلومات الأساسية أمامك',
              ),
              _TrustItem(
                icon:
                Icons.tune_rounded,
                title: 'اختيار أسهل',
                subtitle:
                'فلترة حسب احتياجك',
              ),
              _TrustItem(
                icon: Icons
                    .support_agent_rounded,
                title: 'تواصل مباشر',
                subtitle:
                'فريقنا جاهز لخدمتك',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TrustItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors
                  .secondarySoft,
              borderRadius:
              BorderRadius.circular(
                AppRadius.md,
              ),
              border: Border.all(
                color: AppColors.secondary
                    .withValues(
                  alpha: .13,
                ),
              ),
            ),
            alignment:
            Alignment.center,
            child: Icon(
              icon,
              color:
              AppColors.secondaryDark,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  title,
                  style:
                  GoogleFonts.cairo(
                    color:
                    AppColors.primary,
                    fontWeight:
                    FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  subtitle,
                  style:
                  GoogleFonts.cairo(
                    color: AppColors
                        .textSecondary,
                    fontSize: 11.5,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// FOOTER
// ==========================================================

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration:
      const BoxDecoration(
        gradient: LinearGradient(
          begin:
          Alignment.topRight,
          end:
          Alignment.bottomLeft,
          colors: [
            Color(0xFF102E5E),
            Color(0xFF071A36),
          ],
        ),
      ),
      padding:
      const EdgeInsets.fromLTRB(
        24,
        30,
        24,
        20,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
          const BoxConstraints(
            maxWidth:
            AppLayout.maxContentWidth,
          ),
          child: Column(
            children: [
              Wrap(
                alignment:
                WrapAlignment
                    .spaceBetween,
                spacing: 40,
                runSpacing: 22,
                children: [
                  SizedBox(
                    width: 420,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          'بابل الرياض للاستقدام',
                          style:
                          GoogleFonts.cairo(
                            color: AppColors
                                .textOnPrimary,
                            fontSize: 18,
                            fontWeight:
                            FontWeight
                                .w900,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          'نسهّل عليك استعراض السير الذاتية واختيار المناسب لك.',
                          style:
                          GoogleFonts.cairo(
                            color: AppColors
                                .heroTextSoft,
                            fontSize: 12.5,
                            height: 1.7,
                            fontWeight:
                            FontWeight
                                .w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: 270,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          'تواصل معنا',
                          style:
                          GoogleFonts.cairo(
                            color: AppColors
                                .textOnPrimary,
                            fontSize: 14,
                            fontWeight:
                            FontWeight
                                .w800,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        const _FooterContact(
                          icon:
                          Icons.call_rounded,
                          text:
                          '920005077',
                          ltr: true,
                        ),

                        const _FooterContact(
                          icon: Icons
                              .location_on_outlined,
                          text:
                          'الرياض - المملكة العربية السعودية',
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 24,
              ),

              Divider(
                color: AppColors.surface
                    .withValues(
                  alpha: .12,
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              Text(
                '© بابل الرياض للاستقدام - جميع الحقوق محفوظة',
                textAlign:
                TextAlign.center,
                style:
                GoogleFonts.cairo(
                  color: AppColors
                      .heroTextSoft,
                  fontSize: 11,
                  fontWeight:
                  FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// FOOTER CONTACT
// ==========================================================

class _FooterContact
    extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool ltr;

  const _FooterContact({
    required this.icon,
    required this.text,
    this.ltr = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 8,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color:
            AppColors.secondary,
            size: 16,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              text,
              textDirection: ltr
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              textAlign: ltr
                  ? TextAlign.right
                  : TextAlign.start,
              style:
              GoogleFonts.cairo(
                color: AppColors
                    .heroTextSoft,
                fontSize: 12,
                fontWeight:
                FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// ERROR
// ==========================================================

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function()
  onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 58,
              color:
              AppColors.textMuted,
            ),

            const SizedBox(
              height: 14,
            ),

            Text(
              message,
              textAlign:
              TextAlign.center,
              style:
              GoogleFonts.cairo(
                color: AppColors
                    .textPrimary,
                fontWeight:
                FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: Text(
                'إعادة المحاولة',
                style:
                GoogleFonts.cairo(
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}