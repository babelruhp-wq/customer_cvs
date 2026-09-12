import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../models/candidate_cv_model.dart';
import 'app_header.dart';
import 'inline_pdf_preview.dart';

Future<void> showCvDetailsDialog(
  BuildContext context,
  CandidateCvModel candidate, {
  required List<int> pdfBytes,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: AppColors.overlayStrong,
    builder: (_) => _CvDetailsDialog(
      candidate: candidate,
      pdfBytes: pdfBytes,
    ),
  );
}

class _CvDetailsDialog extends StatelessWidget {
  final CandidateCvModel candidate;
  final List<int> pdfBytes;

  const _CvDetailsDialog({
    required this.candidate,
    required this.pdfBytes,
  });

  void _openCvExternal() {
    final pdfWindow = html.window.open('about:blank', '_blank');

    final blob = html.Blob(
      [pdfBytes],
      'application/pdf',
    );

    final objectUrl = html.Url.createObjectUrlFromBlob(blob);
    pdfWindow.location.href = objectUrl;

    Future<void>.delayed(
      const Duration(seconds: 60),
      () => html.Url.revokeObjectUrl(objectUrl),
    );
  }

  Future<void> _callOffice() async {
    await launchUrl(
      Uri(
        scheme: 'tel',
        path: AppHeader.officePhone,
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
    final size = MediaQuery.sizeOf(context);
    final desktop = size.width >= 980;
    final compact = size.width < 700;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 16,
        vertical: size.height < 700 ? 6 : 12,
      ),
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(compact ? 16 : AppRadius.xl),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: size.width * (compact ? .985 : .975),
        height: size.height * (compact ? .97 : .955),
        child: Column(
          children: [
            _DialogHeader(onOpenExternal: _openCvExternal),
            const Divider(height: 1),
            Expanded(
              child: desktop
                  ? Row(
                      children: [
                        SizedBox(
                          width: 280,
                          child: _DetailsPanel(
                            candidate: candidate,
                            salaryText: _salaryText(candidate.salary),
                            onCallOffice: _callOffice,
                            onOpenExternal: _openCvExternal,
                          ),
                        ),
                        const VerticalDivider(width: 1),
                        Expanded(child: _buildPdf()),
                      ],
                    )
                  : Column(
                      children: [
                        _MobileSummary(
                          candidate: candidate,
                          salaryText: _salaryText(candidate.salary),
                          onOpenExternal: _openCvExternal,
                        ),
                        const Divider(height: 1),
                        Expanded(child: _buildPdf()),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdf() {
    return InlinePdfPreview(
      bytes: pdfBytes,
      compact: false,
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final VoidCallback onOpenExternal;

  const _DialogHeader({
    required this.onOpenExternal,
  });

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 700;

    return Container(
      height: 66,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 15,
        vertical: 9,
      ),
      color: AppColors.surface,
      child: Row(
        children: [
          IconButton(
            tooltip: 'إغلاق',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
          ),
          const SizedBox(width: 5),
          if (!compact) ...[
            const Icon(
              Icons.picture_as_pdf_outlined,
              color: AppColors.primary,
              size: 22,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'عرض السيرة الذاتية',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    color: AppColors.textPrimary,
                    fontSize: compact ? 14 : 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (!compact)
                  Text(
                    'يمكنك التمرير داخل الملف لمشاهدة جميع الصفحات',
                    style: GoogleFonts.cairo(
                      color: AppColors.textSecondary,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: onOpenExternal,
            icon: const Icon(Icons.open_in_new_rounded, size: 17),
            label: Text(
              compact ? 'فتح' : 'فتح في المتصفح',
              style: GoogleFonts.cairo(
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsPanel extends StatelessWidget {
  final CandidateCvModel candidate;
  final String salaryText;
  final VoidCallback onCallOffice;
  final VoidCallback onOpenExternal;

  const _DetailsPanel({
    required this.candidate,
    required this.salaryText,
    required this.onCallOffice,
    required this.onOpenExternal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceMuted,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'معلومات السيرة',
            style: GoogleFonts.cairo(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          _DetailItem(
            icon: Icons.mosque_outlined,
            label: 'الديانة',
            value: candidate.religionLabel,
          ),
          const SizedBox(height: 10),
          _DetailItem(
            icon: Icons.work_history_outlined,
            label: 'الخبرة',
            value: candidate.experienceLabel,
          ),
          const SizedBox(height: 10),
          _DetailItem(
            icon: Icons.payments_outlined,
            label: 'الراتب',
            value: salaryText,
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onOpenExternal,
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: Text(
              'فتح الملف في المتصفح',
              style: GoogleFonts.cairo(fontWeight: FontWeight.w800),
            ),
          ),
          const Spacer(),
          Text(
            'هل السيرة مناسبة لك؟',
            style: GoogleFonts.cairo(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 46,
            child: FilledButton.icon(
              style: AppButtonStyles.success,
              onPressed: onCallOffice,
              icon: const Icon(Icons.call_rounded, size: 18),
              label: Text(
                'تواصل مع المكتب',
                style: GoogleFonts.cairo(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileSummary extends StatelessWidget {
  final CandidateCvModel candidate;
  final String salaryText;
  final VoidCallback onOpenExternal;

  const _MobileSummary({
    required this.candidate,
    required this.salaryText,
    required this.onOpenExternal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _MiniChip(
                    icon: Icons.mosque_outlined,
                    text: candidate.religionLabel,
                  ),
                  const SizedBox(width: 7),
                  _MiniChip(
                    icon: Icons.work_history_outlined,
                    text: candidate.experienceLabel,
                  ),
                  const SizedBox(width: 7),
                  _MiniChip(
                    icon: Icons.payments_outlined,
                    text: salaryText,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'فتح في المتصفح',
            onPressed: onOpenExternal,
            icon: const Icon(Icons.open_in_new_rounded),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 19),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.cairo(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.cairo(
                    color: AppColors.textPrimary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
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

class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MiniChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryFaint,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            text,
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

class _FullPdfLoading extends StatelessWidget {
  const _FullPdfLoading();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceStrong,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 34,
              height: 34,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            const SizedBox(height: 13),
            Text(
              'جاري تجهيز السيرة الذاتية...',
              style: GoogleFonts.cairo(
                color: AppColors.textSecondary,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FullPdfError extends StatelessWidget {
  final VoidCallback onOpenExternal;

  const _FullPdfError({required this.onOpenExternal});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: const BoxDecoration(
                color: AppColors.errorSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.picture_as_pdf_outlined,
                color: AppColors.error,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'تعذر عرض السيرة الذاتية داخل العارض',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'الملف تم تحميله ويمكن فتحه مباشرة في عارض المتصفح.',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: onOpenExternal,
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(
                'فتح في المتصفح',
                style: GoogleFonts.cairo(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
