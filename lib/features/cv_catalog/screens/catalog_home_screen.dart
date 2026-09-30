import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../cubit/cv_catalog_cubit.dart';
import '../cubit/cv_catalog_state.dart';
import '../models/cv_catalog_type.dart';
import '../widgets/countries/countries_hero_section.dart';
import '../widgets/shared/app_header.dart';
import 'countries_screen.dart';

class CatalogHomeScreen extends StatefulWidget {
  const CatalogHomeScreen({super.key});

  @override
  State<CatalogHomeScreen> createState() => _CatalogHomeScreenState();
}

class _CatalogHomeScreenState extends State<CatalogHomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<CvCatalogCubit>().loadCountries(
        catalogType: CvCatalogType.recruitment,
      );
    });
  }

  Future<void> _openCatalog(CvCatalogType catalogType) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CountriesScreen(catalogType: catalogType),
      ),
    );

    if (!mounted) return;

    // رجّع بيانات الاستقدام للهيرو الرئيسي بعد الرجوع
    // من أي قسم، حتى يظل عدد الدول صحيحًا.
    await context.read<CvCatalogCubit>().loadCountries(
      catalogType: CvCatalogType.recruitment,
    );
  }

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
                final recruitmentCountriesCount =
                    state.catalogType == CvCatalogType.recruitment
                    ? state.countries.length
                    : 0;

                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // ==========================================
                    // ORIGINAL HERO
                    // ==========================================
                    SliverToBoxAdapter(
                      child: CountriesHeroSection(
                        countriesCount: recruitmentCountriesCount,
                      ),
                    ),

                    // ==========================================
                    // CATALOG TYPE SECTION
                    // ==========================================
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 34, 20, 10),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1050),
                            child: Column(
                              children: [
                                Text(
                                  'اختر نوع الخدمة',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cairo(
                                    color: AppColors.primary,
                                    fontSize: 29,
                                    height: 1.3,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'اختر الاستقدام أو نقل الخدمات ثم حدد الدولة لاستعراض السير الذاتية المتاحة.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.cairo(
                                    color: AppColors.textSecondary,
                                    fontSize: 13.5,
                                    height: 1.8,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 46),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1050),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final compact = constraints.maxWidth < 760;

                                final recruitmentCard = _CatalogTypeCard(
                                  title: 'الاستقدام',
                                  description:
                                      'استعرض الدول والسير الذاتية المتاحة للاستقدام.',
                                  icon: Icons.public_rounded,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      AppColors.primary,
                                      AppColors.primaryDark,
                                    ],
                                  ),
                                  accentColor: AppColors.secondary,
                                  actionLabel: 'عرض دول الاستقدام',
                                  onTap: () =>
                                      _openCatalog(CvCatalogType.recruitment),
                                );

                                final transferCard = _CatalogTypeCard(
                                  title: 'نقل الخدمات (تسليم فوري)',
                                  description:
                                      'استعرض السير الذاتية المتاحة لنقل الخدمات واختيار الأنسب.',
                                  icon: Icons.swap_horiz_rounded,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color(0xFF16885A),
                                      Color(0xFF0E6845),
                                    ],
                                  ),
                                  accentColor: const Color(0xFFFFD66B),
                                  actionLabel: 'عرض دول نقل الخدمات',
                                  onTap: () => _openCatalog(
                                    CvCatalogType.serviceTransfer,
                                  ),
                                );

                                if (compact) {
                                  return Column(
                                    children: [
                                      recruitmentCard,
                                      const SizedBox(height: 18),
                                      transferCard,
                                    ],
                                  );
                                }

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: recruitmentCard),
                                    const SizedBox(width: 20),
                                    Expanded(child: transferCard),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
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

class _CatalogTypeCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Gradient gradient;
  final Color accentColor;
  final String actionLabel;
  final VoidCallback onTap;

  const _CatalogTypeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.accentColor,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  State<_CatalogTypeCard> createState() => _CatalogTypeCardState();
}

class _CatalogTypeCardState extends State<_CatalogTypeCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() {
        _hovered = true;
      }),
      onExit: (_) => setState(() {
        _hovered = false;
      }),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovered ? -5 : 0, 0),
          height: 285,
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(AppRadius.xxl),
            boxShadow: _hovered ? AppShadows.floating : AppShadows.card,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .13),
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: .14),
                            ),
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.accentColor,
                            size: 28,
                          ),
                        ),
                        const Spacer(),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: _hovered ? .18 : .10,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Text(
                      widget.title,
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 27,
                        height: 1.25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: GoogleFonts.cairo(
                        color: Colors.white.withValues(alpha: .79),
                        fontSize: 13,
                        height: 1.75,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .10),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            widget.actionLabel,
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_back_rounded,
                            color: widget.accentColor,
                            size: 19,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
