import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../../core/theme/app_theme.dart';
import '../../cubit/cv_catalog_cubit.dart';
import '../../models/candidate_cv_model.dart';
import 'cv_pdf_viewer.dart';

class CandidateCard extends StatefulWidget {
  final CandidateCvModel candidate;

  const CandidateCard({
    super.key,
    required this.candidate,
  });

  @override
  State<CandidateCard> createState() => _CandidateCardState();
}

class _CandidateCardState extends State<CandidateCard> {
  late Future<List<int>> _pdfFuture;
  bool _hovered = false;
  bool _opening = false;

  @override
  void initState() {
    super.initState();
    _pdfFuture = _loadPdf();
  }

  @override
  void didUpdateWidget(covariant CandidateCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.candidate.id != widget.candidate.id) {
      _pdfFuture = _loadPdf();
    }
  }

  Future<List<int>> _loadPdf() {
    return context.read<CvCatalogCubit>().getCvPdf(
          widget.candidate.id,
        );
  }

  void _retry() {
    setState(() {
      _pdfFuture = _loadPdf();
    });
  }

  Future<void> _openViewer() async {
    if (_opening) return;

    setState(() {
      _opening = true;
    });

    try {
      final bytes = await _pdfFuture;

      if (!mounted) return;

      if (bytes.isEmpty) {
        _showError(
          'تعذر تحميل ملف السيرة الذاتية.',
        );
        return;
      }

      await showCvPdfViewer(
        context: context,
        bytes: Uint8List.fromList(bytes),
        sourceName: 'cv_${widget.candidate.id}.pdf',
        passportNumber: widget.candidate.passportLabel,
      );
    } catch (_) {
      if (!mounted) return;

      _showError(
        'تعذر فتح السيرة الذاتية. حاول مرة أخرى.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _opening = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
          content: Text(
            message,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
  }

  String _salaryText(num salary) {
    final value = salary.toDouble();

    if (value == value.roundToDouble()) {
      return '${value.toInt()} ريال';
    }

    return '$salary ريال';
  }

  @override
  Widget build(BuildContext context) {
    final candidate = widget.candidate;

    return MouseRegion(
      onEnter: (_) {
        if (mounted) {
          setState(() {
            _hovered = true;
          });
        }
      },
      onExit: (_) {
        if (mounted) {
          setState(() {
            _hovered = false;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          _hovered ? -3 : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            AppRadius.xl,
          ),
          border: Border.all(
            color: _hovered
                ? AppColors.primary.withValues(
                    alpha: .30,
                  )
                : AppColors.border,
          ),
          boxShadow: _hovered
              ? AppShadows.floating
              : AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardHeader(
              candidate: candidate,
              salaryText: _salaryText(
                candidate.salary,
              ),
            ),

            Expanded(
              child: _StaticPdfPreview(
                pdfFuture: _pdfFuture,
                sourceName:
                    'preview_${widget.candidate.id}.pdf',
                onRetry: _retry,
                onTap: _openViewer,
              ),
            ),

            _CardFooter(
              loading: _opening,
              onOpen: _openViewer,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// HEADER
// ==========================================================

class _CardHeader extends StatelessWidget {
  final CandidateCvModel candidate;
  final String salaryText;

  const _CardHeader({
    required this.candidate,
    required this.salaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        15,
        16,
        13,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(
                    AppRadius.md,
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.description_outlined,
                  color: AppColors.primary,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'السيرة الذاتية',
                      style: GoogleFonts.cairo(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        candidate.passportLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          color: AppColors.textSecondary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const _AvailabilityBadge(),
            ],
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              _CompactInfo(
                icon: Icons.mosque_outlined,
                value: candidate.religionLabel,
              ),
              _CompactInfo(
                icon: Icons.work_history_outlined,
                value: candidate.experienceLabel,
              ),
              _CompactInfo(
                icon: Icons.payments_outlined,
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
// STATIC FIRST PAGE PREVIEW
// ==========================================================

class _StaticPdfPreview extends StatelessWidget {
  final Future<List<int>> pdfFuture;
  final String sourceName;
  final VoidCallback onRetry;
  final VoidCallback onTap;

  const _StaticPdfPreview({
    required this.pdfFuture,
    required this.sourceName,
    required this.onRetry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Material(
        color: const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(
          AppRadius.lg,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              FutureBuilder<List<int>>(
                future: pdfFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const _PdfLoading();
                  }

                  final data = snapshot.data;

                  if (snapshot.hasError ||
                      data == null ||
                      data.isEmpty) {
                    return _PdfError(
                      onRetry: onRetry,
                    );
                  }

                  final bytes = data is Uint8List
                      ? data
                      : Uint8List.fromList(data);

                  return IgnorePointer(
                    child: PdfDocumentViewBuilder(
                      documentRef: PdfDocumentRefData(
                        bytes,
                        sourceName: sourceName,
                      ),
                      loadingBuilder: (_) =>
                          const _PdfLoading(),
                      errorBuilder:
                          (_, __, ___) => _PdfError(
                        onRetry: onRetry,
                      ),
                      builder: (
                        context,
                        document,
                      ) {
                        if (document == null) {
                          return const _PdfLoading();
                        }

                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: .08,
                                  ),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(8),
                              child: PdfPageView(
                                document: document,
                                pageNumber: 1,
                                maximumDpi: 150,
                                alignment:
                                    Alignment.topCenter,
                                backgroundColor:
                                    Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: IgnorePointer(
                  child: Center(
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827)
                            .withValues(
                          alpha: .82,
                        ),
                        borderRadius:
                            BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.touch_app_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'اضغط لعرض السيرة كاملة',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
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
// FOOTER
// ==========================================================

class _CardFooter extends StatelessWidget {
  final bool loading;
  final VoidCallback onOpen;

  const _CardFooter({
    required this.loading,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        12,
        10,
        12,
        12,
      ),
      child: SizedBox(
        height: 46,
        child: FilledButton.icon(
          onPressed: loading ? null : onOpen,
          icon: loading
              ? const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(
                  Icons.fullscreen_rounded,
                  size: 21,
                ),
          label: Text(
            loading
                ? 'جاري الفتح...'
                : 'عرض السيرة الذاتية',
            style: GoogleFonts.cairo(
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// SMALL INFO
// ==========================================================

class _CompactInfo extends StatelessWidget {
  final IconData icon;
  final String value;

  const _CompactInfo({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceStrong,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.primary,
          ),
          const SizedBox(width: 5),
          Text(
            value,
            style: GoogleFonts.cairo(
              color: AppColors.textPrimary,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8F0),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'متاح',
        style: GoogleFonts.cairo(
          color: const Color(0xFF157A46),
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

// ==========================================================
// LOADING / ERROR
// ==========================================================

class _PdfLoading extends StatelessWidget {
  const _PdfLoading();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF1F3F6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'جاري تجهيز المعاينة...',
              style: GoogleFonts.cairo(
                color: AppColors.textSecondary,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PdfError extends StatelessWidget {
  final VoidCallback onRetry;

  const _PdfError({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F8FA),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.picture_as_pdf_outlined,
                color: AppColors.error,
                size: 34,
              ),
              const SizedBox(height: 8),
              Text(
                'تعذر عرض المعاينة',
                style: GoogleFonts.cairo(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 17,
                ),
                label: Text(
                  'إعادة المحاولة',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w800,
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
