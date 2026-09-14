import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

/// عارض PDF من bytes تم تحميلها مسبقاً عن طريق Dio.
///
/// نستخدم هنا نفس stack المستخدم في مشروع Babel للـ PDF preview:
/// `printing` + `pdf`، بدل أن يقوم عارض آخر بطلب الملف من الشبكة من جديد.
class InlinePdfPreview extends StatelessWidget {
  final List<int> bytes;
  final bool compact;

  const InlinePdfPreview({
    super.key,
    required this.bytes,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final pdfBytes = Uint8List.fromList(bytes);

    return ColoredBox(
      color: const Color(0xFFF3F5F8),
      child: PdfPreview(
        build: (_) async => pdfBytes,
        initialPageFormat: PdfPageFormat.a4,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        allowPrinting: false,
        allowSharing: false,
        useActions: false,
        maxPageWidth: compact ? 640 : 1100,
        loadingWidget: const Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          ),
        ),
      ),
    );
  }
}
