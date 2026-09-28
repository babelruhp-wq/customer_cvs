import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

/// عارض PDF يستخدم عارض الـ PDF الأصلي الخاص بالمتصفح.
///
/// المميزات:
/// - Scroll طبيعي داخل الملف.
/// - Zoom من أدوات عارض الـ PDF في المتصفح.
/// - Mouse / Trackpad بشكل طبيعي.
/// - Pinch Zoom على الأجهزة والمتصفحات التي تدعمه.
/// - لا يوجد InteractiveViewer ولا Zoom مخصص من Flutter.
/// - الـ PDF يتم عرضه من bytes تم تحميلها مسبقاً، بدون طلب شبكة جديد.
///
/// ملاحظة:
/// هذا الـ Widget مخصص لـ Flutter Web.
class InlinePdfPreview extends StatefulWidget {
  final List<int> bytes;
  final bool compact;

  const InlinePdfPreview({
    super.key,
    required this.bytes,
    this.compact = false,
  });

  @override
  State<InlinePdfPreview> createState() =>
      _InlinePdfPreviewState();
}

class _InlinePdfPreviewState
    extends State<InlinePdfPreview> {
  static int _viewerCounter = 0;

  late final String _viewType;
  late final html.IFrameElement _iframe;

  String? _objectUrl;

  @override
  void initState() {
    super.initState();

    _viewType =
    'native-pdf-viewer-${_viewerCounter++}';

    _iframe = html.IFrameElement()
      ..style.border = '0'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.display = 'block'
      ..style.backgroundColor = '#F3F5F8'
      ..setAttribute(
        'title',
        'PDF Viewer',
      );

    // مهم للموبايل:
    // نترك المتصفح يتعامل مع اللمس والـ scroll والـ pinch
    // داخل عارض الـ PDF بشكل طبيعي.
    _iframe.style.setProperty(
      'touch-action',
      'auto',
    );

    ui_web.platformViewRegistry
        .registerViewFactory(
      _viewType,
          (int viewId) => _iframe,
    );

    _loadPdfIntoViewer();
  }

  @override
  void didUpdateWidget(
      covariant InlinePdfPreview oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (!_sameBytes(
      oldWidget.bytes,
      widget.bytes,
    )) {
      _loadPdfIntoViewer();
    }
  }

  @override
  void dispose() {
    final url = _objectUrl;

    if (url != null) {
      html.Url.revokeObjectUrl(url);
    }

    _iframe.src = 'about:blank';

    super.dispose();
  }

  // =========================================================
  // LOAD PDF
  // =========================================================

  void _loadPdfIntoViewer() {
    final previousUrl = _objectUrl;

    if (widget.bytes.isEmpty) {
      _iframe.src = 'about:blank';

      if (previousUrl != null) {
        html.Url.revokeObjectUrl(
          previousUrl,
        );
      }

      _objectUrl = null;

      return;
    }

    final pdfBytes =
    Uint8List.fromList(
      widget.bytes,
    );

    final blob = html.Blob(
      <dynamic>[
        pdfBytes,
      ],
      'application/pdf',
    );

    final objectUrl =
    html.Url.createObjectUrlFromBlob(
      blob,
    );

    _objectUrl = objectUrl;

    // نمرر الرابط كما هو للمتصفح.
    // بذلك المتصفح يستخدم عارض الـ PDF الأصلي
    // بكل خصائصه الطبيعية.
    _iframe.src = objectUrl;

    if (previousUrl != null) {
      // ننتظر قليلاً قبل تحرير الرابط القديم
      // حتى لا نقطع التحميل أثناء استبدال الملف.
      Future<void>.delayed(
        const Duration(
          seconds: 2,
        ),
            () {
          html.Url.revokeObjectUrl(
            previousUrl,
          );
        },
      );
    }
  }

  // =========================================================
  // BYTES COMPARISON
  // =========================================================

  bool _sameBytes(
      List<int> a,
      List<int> b,
      ) {
    if (identical(a, b)) {
      return true;
    }

    if (a.length != b.length) {
      return false;
    }

    // في الحالة الطبيعية الـ CandidateCard لا يغير
    // نفس الـ PDF باستمرار، لذلك المقارنة البسيطة كافية.
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }

    return true;
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    if (widget.bytes.isEmpty) {
      return const ColoredBox(
        color: Color(
          0xFFF3F5F8,
        ),
        child: Center(
          child: Icon(
            Icons.picture_as_pdf_outlined,
            size: 32,
            color: Color(
              0xFF98A2B3,
            ),
          ),
        ),
      );
    }

    return ColoredBox(
      color: const Color(
        0xFFF3F5F8,
      ),
      child: HtmlElementView(
        viewType: _viewType,
      ),
    );
  }
}
