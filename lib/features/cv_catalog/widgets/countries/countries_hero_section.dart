import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';

class CountriesHeroSection extends StatelessWidget {
  final int countriesCount;

  const CountriesHeroSection({required this.countriesCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF102E5E), Color(0xFF0A2348), Color(0xFF071A36)],
          stops: [0.0, .55, 1.0],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayout.maxContentWidth,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              final mobile = width < 700;

              final tablet = width >= 700 && width < 1050;

              // =============================================
              // MOBILE
              // =============================================

              if (mobile) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(18, 24, 18, 34),
                  child: Column(
                    children: [
                      const _HeroWatermarkLogo(
                        width: 280,
                        height: 210,
                        logoWidth: 225,
                      ),

                      const SizedBox(height: 8),

                      _HeroContent(
                        countriesCount: countriesCount,
                        mobile: true,
                      ),
                    ],
                  ),
                );
              }

              // =============================================
              // TABLET
              // =============================================

              if (tablet) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(28, 30, 28, 36),
                  child: Column(
                    children: [
                      const _HeroWatermarkLogo(
                        width: 360,
                        height: 245,
                        logoWidth: 290,
                      ),

                      const SizedBox(height: 8),

                      _HeroContent(
                        countriesCount: countriesCount,
                        tablet: true,
                      ),
                    ],
                  ),
                );
              }

              // =============================================
              // DESKTOP
              // =============================================

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 5,
                        child: _HeroWatermarkLogo(
                          width: 520,
                          height: 350,
                          logoWidth: 395,
                        ),
                      ),

                      const SizedBox(width: 34),

                      Expanded(
                        flex: 7,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: _HeroContent(countriesCount: countriesCount),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// HERO LOGO
// ==========================================================

class _HeroWatermarkLogo extends StatelessWidget {
  final double width;
  final double height;
  final double logoWidth;

  const _HeroWatermarkLogo({
    this.width = 520,
    this.height = 350,
    this.logoWidth = 395,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width / 2),
                gradient: RadialGradient(
                  center: const Alignment(0, 0.12),
                  radius: .82,
                  colors: [
                    AppColors.surface.withValues(alpha: .30),
                    AppColors.surface.withValues(alpha: .19),
                    AppColors.secondary.withValues(alpha: .045),
                    AppColors.surface.withValues(alpha: .035),
                    AppColors.transparent,
                  ],
                  stops: const [0.0, .34, .58, .76, 1.0],
                ),
              ),
            ),

            SizedBox(
              width: logoWidth,
              height: height * .90,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// HERO CONTENT
// ==========================================================

class _HeroContent extends StatelessWidget {
  final int countriesCount;
  final bool mobile;
  final bool tablet;

  const _HeroContent({
    required this.countriesCount,
    this.mobile = false,
    this.tablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final centerContent = mobile || tablet;

    final titleSize = mobile
        ? 28.0
        : tablet
        ? 32.0
        : 39.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centerContent
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: .075),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: AppColors.surface.withValues(alpha: .12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'بابل الرياض للاستقدام',
                style: GoogleFonts.cairo(
                  color: AppColors.heroTextSoft,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 17),

        Text(
          mobile
              ? 'اختر السيرة المناسبة\nبكل سهولة'
              : 'اختر السيرة المناسبة\nبكل سهولة',
          textAlign: centerContent ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.cairo(
            color: AppColors.textOnPrimary,
            fontSize: titleSize,
            height: 1.30,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 13),

        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: mobile
                ? 430
                : tablet
                ? 560
                : 600,
          ),
          child: Text(
            'استعرض السير الذاتية المتاحة حسب الدولة، واستخدم الفلاتر للوصول إلى الاختيار المناسب لك.',
            textAlign: centerContent ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.cairo(
              color: AppColors.heroTextSoft,
              fontSize: mobile ? 12.5 : 13.5,
              height: 1.9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: 24),

        Wrap(
          alignment: centerContent ? WrapAlignment.center : WrapAlignment.start,
          spacing: 10,
          runSpacing: 10,
          children: [
            _HeroStat(
              icon: Icons.public_rounded,
              value: '$countriesCount',
              label: 'دول متاحة',
              compact: mobile,
            ),

            _HeroStat(
              icon: Icons.picture_as_pdf_outlined,
              value: 'مباشر',
              label: 'عرض السيرة',
              compact: mobile,
            ),

            _HeroStat(
              icon: Icons.tune_rounded,
              value: 'سهل',
              label: 'فلترة سريعة',
              compact: mobile,
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
  final bool compact;

  const _HeroStat({
    required this.icon,
    required this.value,
    required this.label,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: compact ? 112 : 132),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 11 : 14,
        vertical: compact ? 9 : 11,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: .075),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.surface.withValues(alpha: .11)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 31 : 35,
            height: compact ? 31 : 35,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: .13),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: .10),
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: compact ? 15 : 17,
              color: AppColors.secondary,
            ),
          ),

          const SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: GoogleFonts.cairo(
                  color: AppColors.textOnPrimary,
                  fontSize: compact ? 12.5 : 14,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                label,
                style: GoogleFonts.cairo(
                  color: AppColors.heroTextSoft,
                  fontSize: compact ? 9 : 10,
                  fontWeight: FontWeight.w600,
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
