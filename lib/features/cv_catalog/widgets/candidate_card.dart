import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../cubit/cv_catalog_cubit.dart';
import '../models/candidate_cv_model.dart';
import 'cv_details_dialog.dart';
import 'inline_pdf_preview.dart';

class CandidateCard extends StatefulWidget {
  final CandidateCvModel candidate;

  const CandidateCard({
    super.key,
    required this.candidate,
  });

  @override
  State<CandidateCard> createState() =>
      _CandidateCardState();
}

class _CandidateCardState
    extends State<CandidateCard> {
  late Future<List<int>> _pdfFuture;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _pdfFuture = _loadPdf();
  }

  @override
  void didUpdateWidget(
      covariant CandidateCard oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.candidate.id !=
        widget.candidate.id) {
      _pdfFuture = _loadPdf();
    }
  }

  Future<List<int>> _loadPdf() {
    return context
        .read<CvCatalogCubit>()
        .getCvPdf(
      widget.candidate.id,
    );
  }

  void _retry() {
    setState(() {
      _pdfFuture = _loadPdf();
    });
  }

  Future<void> _openDetails() async {
    try {
      final bytes = await _pdfFuture;

      if (!mounted) return;

      await showCvDetailsDialog(
        context,
        widget.candidate,
        pdfBytes: bytes,
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior:
            SnackBarBehavior.floating,
            backgroundColor:
            AppColors.error,
            content: Text(
              'تعذر تحميل ملف السيرة الذاتية. اضغط إعادة المحاولة.',
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontWeight:
                FontWeight.w800,
              ),
            ),
          ),
        );
    }
  }

  String _salaryText(
      num salary,
      ) {
    final value =
    salary.toDouble();

    if (value ==
        value.roundToDouble()) {
      return '${value.toInt()} ريال';
    }

    return '$salary ريال';
  }

  @override
  Widget build(BuildContext context) {
    final candidate =
        widget.candidate;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovered = false;
        });
      },
      child: AnimatedContainer(
        duration:
        const Duration(
          milliseconds: 180,
        ),
        curve: Curves.easeOut,
        transform:
        Matrix4.translationValues(
          0,
          _hovered ? -3 : 0,
          0,
        ),
        decoration: BoxDecoration(
          color:
          AppColors.surface,
          borderRadius:
          BorderRadius.circular(
            AppRadius.xl,
          ),
          border: Border.all(
            color: _hovered
                ? AppColors.primary
                .withValues(
              alpha: .30,
            )
                : AppColors.border,
          ),
          boxShadow: _hovered
              ? AppShadows.floating
              : AppShadows.card,
        ),
        clipBehavior:
        Clip.antiAlias,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.stretch,
          children: [
            _CardHeader(
              candidate: candidate,
              salaryText:
              _salaryText(
                candidate.salary,
              ),
            ),

            Expanded(
              child: _PdfPreview(
                pdfFuture:
                _pdfFuture,
                onRetry: _retry,
              ),
            ),

            _CardFooter(
              onOpen: _openDetails,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// CARD HEADER
// ==========================================================

class _CardHeader
    extends StatelessWidget {
  final CandidateCvModel candidate;
  final String salaryText;

  const _CardHeader({
    required this.candidate,
    required this.salaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.fromLTRB(
        18,
        16,
        18,
        15,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration:
                BoxDecoration(
                  color: AppColors
                      .primarySoft,
                  borderRadius:
                  BorderRadius.circular(
                    AppRadius.md,
                  ),
                ),
                alignment:
                Alignment.center,
                child: const Icon(
                  Icons
                      .description_outlined,
                  color:
                  AppColors.primary,
                  size: 22,
                ),
              ),

              const SizedBox(
                width: 11,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      'السيرة الذاتية',
                      style:
                      GoogleFonts.cairo(
                        color: AppColors
                            .textPrimary,
                        fontSize: 16,
                        fontWeight:
                        FontWeight
                            .w900,
                      ),
                    ),

                    const SizedBox(
                      height: 2,
                    ),

                    Text(
                      'يمكنك معاينة الملف كاملًا من نفس البطاقة',
                      maxLines: 1,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style:
                      GoogleFonts.cairo(
                        color: AppColors
                            .textSecondary,
                        fontSize: 10.5,
                        fontWeight:
                        FontWeight
                            .w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              const _AvailabilityBadge(),
            ],
          ),

          const SizedBox(
            height: 14,
          ),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // ============================================
              // PASSPORT NUMBER
              // ============================================

              _InfoPill(
                icon:
                Icons.badge_outlined,
                label: 'رقم الجواز',
                value:
                candidate.passportLabel,
                valueTextDirection:
                TextDirection.ltr,
              ),

              // ============================================
              // RELIGION
              // ============================================

              _InfoPill(
                icon:
                Icons.mosque_outlined,
                label: 'الديانة',
                value: candidate
                    .religionLabel,
              ),

              // ============================================
              // EXPERIENCE
              // ============================================

              _InfoPill(
                icon: Icons
                    .work_history_outlined,
                label: 'الخبرة',
                value: candidate
                    .experienceLabel,
              ),

              // ============================================
              // SALARY
              // ============================================

              _InfoPill(
                icon:
                Icons.payments_outlined,
                label: 'الراتب',
                value: salaryText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// PDF PREVIEW
// ==========================================================

class _PdfPreview
    extends StatelessWidget {
  final Future<List<int>> pdfFuture;
  final VoidCallback onRetry;

  const _PdfPreview({
    required this.pdfFuture,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
      const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color:
        AppColors.surfaceStrong,
        borderRadius:
        BorderRadius.circular(
          AppRadius.lg,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      clipBehavior:
      Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 44,
            padding:
            const EdgeInsets.symmetric(
              horizontal: 13,
            ),
            color:
            AppColors.primaryDark,
            child: Row(
              children: [
                const Icon(
                  Icons
                      .picture_as_pdf_outlined,
                  size: 17,
                  color: AppColors
                      .textOnPrimary,
                ),

                const SizedBox(
                  width: 7,
                ),

                Text(
                  'معاينة السيرة الذاتية',
                  style:
                  GoogleFonts.cairo(
                    color: AppColors
                        .textOnPrimary,
                    fontSize: 11.5,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),

                const Spacer(),

                Text(
                  'مرر داخل الملف لعرض باقي الصفحات',
                  style:
                  GoogleFonts.cairo(
                    color: AppColors
                        .textOnPrimary
                        .withValues(
                      alpha: .72,
                    ),
                    fontSize: 9.5,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child:
            FutureBuilder<List<int>>(
              future: pdfFuture,
              builder: (
                  context,
                  snapshot,
                  ) {
                if (snapshot
                    .connectionState ==
                    ConnectionState
                        .waiting) {
                  return const _PdfLoading();
                }

                final bytes =
                    snapshot.data;

                if (snapshot.hasError ||
                    bytes == null ||
                    bytes.isEmpty) {
                  return _PdfError(
                    onRetry:
                    onRetry,
                  );
                }

                return InlinePdfPreview(
                  bytes: bytes,
                  compact: true,
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
// CARD FOOTER
// ==========================================================

class _CardFooter
    extends StatelessWidget {
  final VoidCallback onOpen;

  const _CardFooter({
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.fromLTRB(
        14,
        12,
        14,
        14,
      ),
      child: SizedBox(
        height: 48,
        child: FilledButton.icon(
          onPressed: onOpen,
          icon: const Icon(
            Icons.fullscreen_rounded,
            size: 21,
          ),
          label: Text(
            'عرض السيرة الذاتية',
            style:
            GoogleFonts.cairo(
              fontSize: 13,
              fontWeight:
              FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// PDF LOADING
// ==========================================================

class _PdfLoading
    extends StatelessWidget {
  const _PdfLoading();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color:
      AppColors.surfaceStrong,
      child: Center(
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            const SizedBox(
              width: 30,
              height: 30,
              child:
              CircularProgressIndicator(
                strokeWidth: 2.5,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              'جاري تحميل السيرة الذاتية...',
              style:
              GoogleFonts.cairo(
                color: AppColors
                    .textSecondary,
                fontSize: 11,
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// PDF ERROR
// ==========================================================

class _PdfError
    extends StatelessWidget {
  final VoidCallback onRetry;

  const _PdfError({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color:
      AppColors.surfaceStrong,
      child: Center(
        child: Padding(
          padding:
          const EdgeInsets.all(
            22,
          ),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration:
                const BoxDecoration(
                  color:
                  AppColors.errorSoft,
                  shape:
                  BoxShape.circle,
                ),
                child: const Icon(
                  Icons
                      .picture_as_pdf_outlined,
                  color:
                  AppColors.error,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              Text(
                'تعذر تحميل السيرة الذاتية',
                textAlign:
                TextAlign.center,
                style:
                GoogleFonts.cairo(
                  color: AppColors
                      .textPrimary,
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w900,
                ),
              ),

              const SizedBox(
                height: 5,
              ),

              Text(
                'اضغط إعادة المحاولة لتحميل الملف مرة أخرى.',
                textAlign:
                TextAlign.center,
                style:
                GoogleFonts.cairo(
                  color: AppColors
                      .textSecondary,
                  fontSize: 10.5,
                  height: 1.55,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 17,
                ),
                label: Text(
                  'إعادة المحاولة',
                  style:
                  GoogleFonts.cairo(
                    fontWeight:
                    FontWeight
                        .w800,
                  ),
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
// AVAILABILITY BADGE
// ==========================================================

class _AvailabilityBadge
    extends StatelessWidget {
  const _AvailabilityBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color:
        AppColors.accentSoft,
        borderRadius:
        BorderRadius.circular(
          AppRadius.pill,
        ),
        border: Border.all(
          color: AppColors.accent
              .withValues(
            alpha: .18,
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
              AppColors.accent,
              shape:
              BoxShape.circle,
            ),
          ),

          const SizedBox(
            width: 5,
          ),

          Text(
            'متاحة',
            style:
            GoogleFonts.cairo(
              color:
              AppColors.accentDark,
              fontSize: 10,
              fontWeight:
              FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// INFO PILL
// ==========================================================

class _InfoPill
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final TextDirection?
  valueTextDirection;

  const _InfoPill({
    required this.icon,
    required this.label,
    required this.value,
    this.valueTextDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color:
        AppColors.primaryFaint,
        borderRadius:
        BorderRadius.circular(
          AppRadius.md,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color:
            AppColors.primary,
          ),

          const SizedBox(
            width: 6,
          ),

          Text(
            '$label: ',
            style:
            GoogleFonts.cairo(
              color:
              AppColors.textMuted,
              fontSize: 10.5,
              fontWeight:
              FontWeight.w600,
            ),
          ),

          Directionality(
            textDirection:
            valueTextDirection ??
                TextDirection.rtl,
            child: Text(
              value,
              style:
              GoogleFonts.cairo(
                color: AppColors
                    .textPrimary,
                fontSize: 10.5,
                fontWeight:
                FontWeight.w800,
                letterSpacing:
                valueTextDirection ==
                    TextDirection
                        .ltr
                    ? .5
                    : 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}