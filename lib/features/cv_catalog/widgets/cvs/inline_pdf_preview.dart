import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

/// PDF viewer مخصص لتجربة سلسة على الكمبيوتر والهاتف.
///
/// السلوك:
/// - الصفحات تحت بعض Vertical بشكل مستمر.
/// - عند الوصول لنهاية الصفحة، يكمل مباشرة للصفحة التالية بالسحب لأعلى.
/// - Pinch zoom بإصبعين على الهاتف.
/// - Pan أفقي عند التكبير لرؤية جوانب الصفحة.
/// - السحب الرأسي يظل رأسيًا قدر الإمكان.
/// - Zoom + / -.
/// - Mouse wheel على الكمبيوتر يعمل Scroll طبيعي.
/// - Preload للصفحات القريبة لتقليل التقطيع أثناء القراءة.
class InlinePdfPreview extends StatefulWidget {
  final List<int> bytes;
  final bool compact;

  const InlinePdfPreview({
    super.key,
    required this.bytes,
    this.compact = false,
  });

  @override
  State<InlinePdfPreview> createState() => _InlinePdfPreviewState();
}

class _InlinePdfPreviewState extends State<InlinePdfPreview> {
  final PdfViewerController _controller = PdfViewerController();

  int _currentPage = 1;
  int _pageCount = 0;
  double _zoom = 1.0;

  bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (!_controller.isReady) return;

    final zoom = _controller.currentZoom;
    final page = _controller.pageNumber ?? _currentPage;
    final count = _controller.pageCount;

    if ((zoom - _zoom).abs() < .01 &&
        page == _currentPage &&
        count == _pageCount) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _zoom = zoom;
      _currentPage = page;
      _pageCount = count;
    });
  }

  Future<void> _zoomIn() async {
    if (!_controller.isReady) return;

    await _controller.zoomUp(
      loop: false,
      duration: const Duration(milliseconds: 180),
    );
  }

  Future<void> _zoomOut() async {
    if (!_controller.isReady) return;

    await _controller.zoomDown(
      loop: false,
      duration: const Duration(milliseconds: 180),
    );
  }

  Future<void> _fitPageWidth() async {
    if (!_controller.isReady) return;

    final pageNumber = _controller.pageNumber ?? 1;
    final matrix = _controller.calcMatrixFitWidthForPage(
      pageNumber: pageNumber,
    );

    if (matrix == null) return;

    await _controller.goTo(
      matrix,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bytes.isEmpty) {
      return const ColoredBox(
        color: Color(0xFFF3F5F8),
        child: Center(
          child: Icon(
            Icons.picture_as_pdf_outlined,
            size: 34,
            color: Color(0xFF98A2B3),
          ),
        ),
      );
    }

    final pdfBytes = Uint8List.fromList(widget.bytes);

    final ScrollPhysics scrollPhysics = _isIOS
        ? const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    )
        : const ClampingScrollPhysics();

    return ColoredBox(
      color: const Color(0xFFF3F5F8),
      child: Stack(
        children: [
          Positioned.fill(
            child: PdfViewer.data(
              pdfBytes,
              sourceName: 'cv_preview.pdf',
              controller: _controller,
              params: PdfViewerParams(
                margin: widget.compact ? 6 : 10,
                backgroundColor: const Color(0xFFF3F5F8),

                // السحب يتثبت غالبًا على اتجاه الحركة:
                // رأسي للقراءة، وأفقي لرؤية الجوانب عند التكبير.
                panAxis: PanAxis.aligned,

                panEnabled: true,
                scaleEnabled: true,

                scrollPhysics: scrollPhysics,
                scrollPhysicsScale: scrollPhysics,

                // عجلة الماوس تعمل Scroll عادي.
                scrollByMouseWheel: .20,
                scrollHorizontallyByMouseWheel: false,

                // Preload للصفحات القريبة عشان الانتقال بينها يبقى سلس.
                verticalCacheExtent: widget.compact ? 2.0 : 2.5,
                horizontalCacheExtent: 1.0,

                pageAnchor: PdfPageAnchor.top,
                pageAnchorEnd: PdfPageAnchor.bottom,
                underflowAnchor: PdfPageAnchor.top,

                limitRenderingCache: true,

                behaviorControlParams:
                const PdfViewerBehaviorControlParams(
                  enableLowResolutionPagePreview: true,
                ),

                onViewerReady: (
                    document,
                    controller,
                    ) {
                  if (!mounted) return;

                  setState(() {
                    _pageCount = controller.pageCount;
                    _currentPage = controller.pageNumber ?? 1;
                    _zoom = controller.currentZoom;
                  });
                },

                onPageChanged: (pageNumber) {
                  if (!mounted || pageNumber == null) return;

                  setState(() {
                    _currentPage = pageNumber;
                  });
                },
              ),
            ),
          ),

          Positioned(
            top: widget.compact ? 8 : 12,
            left: widget.compact ? 8 : 12,
            child: _ViewerControls(
              compact: widget.compact,
              zoom: _zoom,
              currentPage: _currentPage,
              pageCount: _pageCount,
              onZoomOut: _zoomOut,
              onZoomIn: _zoomIn,
              onFitWidth: _fitPageWidth,
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewerControls extends StatelessWidget {
  final bool compact;
  final double zoom;
  final int currentPage;
  final int pageCount;

  final VoidCallback onZoomOut;
  final VoidCallback onZoomIn;
  final VoidCallback onFitWidth;

  const _ViewerControls({
    required this.compact,
    required this.zoom,
    required this.currentPage,
    required this.pageCount,
    required this.onZoomOut,
    required this.onZoomIn,
    required this.onFitWidth,
  });

  @override
  Widget build(BuildContext context) {
    final zoomPercent = (zoom * 100).round();

    return Material(
      elevation: 5,
      color: Colors.white.withValues(alpha: .95),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 4 : 6,
          vertical: compact ? 3 : 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ControlButton(
              tooltip: 'تصغير',
              icon: Icons.remove_rounded,
              compact: compact,
              onPressed: onZoomOut,
            ),

            InkWell(
              onTap: onFitWidth,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 6 : 8,
                  vertical: compact ? 5 : 7,
                ),
                child: Text(
                  '$zoomPercent%',
                  style: TextStyle(
                    color: const Color(0xFF2C334A),
                    fontSize: compact ? 10 : 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            _ControlButton(
              tooltip: 'تكبير',
              icon: Icons.add_rounded,
              compact: compact,
              onPressed: onZoomIn,
            ),

            if (pageCount > 1) ...[
              const SizedBox(width: 4),
              Container(
                width: 1,
                height: 18,
                color: const Color(0xFFE5E7EB),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                child: Text(
                  '$currentPage / $pageCount',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: const Color(0xFF667085),
                    fontSize: compact ? 9 : 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final bool compact;
  final VoidCallback onPressed;

  const _ControlButton({
    required this.tooltip,
    required this.icon,
    required this.compact,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        constraints: BoxConstraints.tightFor(
          width: compact ? 30 : 34,
          height: compact ? 30 : 34,
        ),
        icon: Icon(
          icon,
          size: compact ? 17 : 19,
        ),
      ),
    );
  }
}
