import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../../core/theme/app_theme.dart';

Future<void> showCvPdfViewer({
  required BuildContext context,
  required Uint8List bytes,
  required String sourceName,
  required String passportNumber,
}) async {
  final width = MediaQuery.sizeOf(context).width;
  final isMobile = width < 760;

  if (isMobile) {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _CvPdfViewerPage(
          bytes: bytes,
          sourceName: sourceName,
          passportNumber: passportNumber,
        ),
      ),
    );
    return;
  }

  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(
      alpha: .66,
    ),
    builder: (dialogContext) {
      final size = MediaQuery.sizeOf(
        dialogContext,
      );

      return Dialog(
        insetPadding: const EdgeInsets.all(24),
        clipBehavior: Clip.antiAlias,
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: size.width * .90,
          height: size.height * .90,
          child: _CvPdfViewerShell(
            bytes: bytes,
            sourceName: sourceName,
            passportNumber: passportNumber,
            onClose: () =>
                Navigator.of(dialogContext).pop(),
          ),
        ),
      );
    },
  );
}

class _CvPdfViewerPage extends StatelessWidget {
  final Uint8List bytes;
  final String sourceName;
  final String passportNumber;

  const _CvPdfViewerPage({
    required this.bytes,
    required this.sourceName,
    required this.passportNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161A22),
      body: SafeArea(
        child: _CvPdfViewerShell(
          bytes: bytes,
          sourceName: sourceName,
          passportNumber: passportNumber,
          onClose: () =>
              Navigator.of(context).maybePop(),
        ),
      ),
    );
  }
}

class _CvPdfViewerShell extends StatefulWidget {
  final Uint8List bytes;
  final String sourceName;
  final String passportNumber;
  final VoidCallback onClose;

  const _CvPdfViewerShell({
    required this.bytes,
    required this.sourceName,
    required this.passportNumber,
    required this.onClose,
  });

  @override
  State<_CvPdfViewerShell> createState() =>
      _CvPdfViewerShellState();
}

class _CvPdfViewerShellState
    extends State<_CvPdfViewerShell> {
  final PdfViewerController _controller =
      PdfViewerController();

  Matrix4? _initialMatrix;
  double _baseZoom = 1;
  int _percent = 100;
  int _page = 1;
  int _pageCount = 0;
  bool _ready = false;

  bool get _desktopLike =>
      const {
        TargetPlatform.windows,
        TargetPlatform.macOS,
        TargetPlatform.linux,
      }.contains(defaultTargetPlatform);

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      _onControllerChanged,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(
      _onControllerChanged,
    );
    super.dispose();
  }

  void _onControllerChanged() {
    if (!_ready || !_controller.isReady) {
      return;
    }

    final zoom =
        (_controller.currentZoom / _baseZoom * 100)
            .clamp(10, 1000)
            .round();

    final page =
        _controller.pageNumber ?? _page;

    if (zoom == _percent &&
        page == _page) {
      return;
    }

    setState(() {
      _percent = zoom;
      _page = page;
    });
  }

  void _onViewerReady(
    PdfDocument document,
    PdfViewerController controller,
  ) {
    _initialMatrix =
        controller.value.clone();
    _baseZoom = controller.currentZoom;

    if (!mounted) return;

    setState(() {
      _ready = true;
      _pageCount = document.pages.length;
      _page = controller.pageNumber ?? 1;
      _percent = 100;
    });
  }

  void _zoomIn() {
    if (_ready) {
      _controller.zoomUp();
    }
  }

  void _zoomOut() {
    if (_ready) {
      _controller.zoomDown();
    }
  }

  void _resetZoom() {
    final matrix = _initialMatrix;

    if (matrix != null) {
      _controller.goTo(matrix);
    }
  }

  @override
  Widget build(BuildContext context) {
    final compact =
        MediaQuery.sizeOf(context).width < 760;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: compact
            ? BorderRadius.zero
            : BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _ViewerHeader(
            passportNumber:
                widget.passportNumber,
            page: _page,
            pageCount: _pageCount,
            percent: _percent,
            ready: _ready,
            compact: compact,
            onClose: widget.onClose,
            onZoomIn: _zoomIn,
            onZoomOut: _zoomOut,
            onReset: _resetZoom,
          ),

          Expanded(
            child: ColoredBox(
              color: const Color(0xFFE8EBF0),
              child: PdfViewer.data(
                widget.bytes,
                sourceName:
                    widget.sourceName,
                controller: _controller,
                params: PdfViewerParams(
                  backgroundColor:
                      const Color(0xFFE8EBF0),
                  margin: compact ? 8 : 16,
                  maxScale: 6,
                  panAxis: PanAxis.aligned,
                  panEnabled: true,
                  scaleEnabled: true,
                  textSelectionParams:
                      PdfTextSelectionParams(
                    enabled:
                        _desktopLike,
                  ),
                  onViewerReady:
                      _onViewerReady,
                  loadingBannerBuilder:
                      (
                        context,
                        downloaded,
                        total,
                      ) =>
                          const Center(
                    child:
                        CircularProgressIndicator(),
                  ),
                  errorBannerBuilder:
                      (
                        context,
                        error,
                        stackTrace,
                        source,
                      ) =>
                          Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                        24,
                      ),
                      child: Text(
                        'تعذر عرض ملف السيرة الذاتية',
                        textAlign:
                            TextAlign.center,
                        style:
                            GoogleFonts.cairo(
                          color:
                              AppColors.error,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewerHeader extends StatelessWidget {
  final String passportNumber;
  final int page;
  final int pageCount;
  final int percent;
  final bool ready;
  final bool compact;
  final VoidCallback onClose;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;

  const _ViewerHeader({
    required this.passportNumber,
    required this.page,
    required this.pageCount,
    required this.percent,
    required this.ready,
    required this.compact,
    required this.onClose,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 58 : 64,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 14,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF102E5E),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'إغلاق',
            onPressed: onClose,
            icon: Icon(
              compact
                  ? Icons.arrow_back_rounded
                  : Icons.close_rounded,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'السيرة الذاتية',
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize:
                        compact ? 13 : 14,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 1),
                Directionality(
                  textDirection:
                      TextDirection.ltr,
                  child: Text(
                    passportNumber,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      color: Colors.white
                          .withValues(
                        alpha: .72,
                      ),
                      fontSize: 10,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (ready && pageCount > 0) ...[
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: .12,
                ),
                borderRadius:
                    BorderRadius.circular(
                  999,
                ),
              ),
              child: Text(
                '$page / $pageCount',
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: 10.5,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],

          _HeaderIconButton(
            tooltip: 'تصغير',
            icon: Icons.remove_rounded,
            enabled: ready &&
                percent > 55,
            onPressed: onZoomOut,
          ),

          InkWell(
            onTap:
                ready ? onReset : null,
            borderRadius:
                BorderRadius.circular(8),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 8,
              ),
              child: Text(
                '$percent%',
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize:
                      compact ? 10 : 11,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ),
          ),

          _HeaderIconButton(
            tooltip: 'تكبير',
            icon: Icons.add_rounded,
            enabled: ready &&
                percent < 590,
            onPressed: onZoomIn,
          ),

          if (!compact)
            _HeaderIconButton(
              tooltip:
                  'الحجم الطبيعي',
              icon:
                  Icons.restart_alt_rounded,
              enabled: ready &&
                  (percent - 100).abs() >
                      1,
              onPressed: onReset,
            ),
        ],
      ),
    );
  }
}

class _HeaderIconButton
    extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  const _HeaderIconButton({
    required this.tooltip,
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed:
            enabled ? onPressed : null,
        visualDensity:
            VisualDensity.compact,
        iconSize: 20,
        color: Colors.white,
        disabledColor:
            Colors.white.withValues(
          alpha: .28,
        ),
        icon: Icon(icon),
      ),
    );
  }
}
