import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';
import 'dart:ui' show PointerDeviceKind;
/// عارض PDF من bytes محمّلة مسبقاً (Dio).
///
/// - Desktop/Web: عجلة الماوس = Scroll، Ctrl+عجلة = Zoom، أزرار + و -،
///   اختصارات Ctrl + / Ctrl - / Ctrl 0، وسحب بالماوس.
/// - Mobile: Scroll بإصبع، Pinch Zoom، Double-tap، وأزرار + و -.
class InlinePdfPreview extends StatefulWidget {
  final List<int> bytes;
  final bool compact;
  final String? sourceName;
  final ValueChanged<bool>? onInteractionChanged;

  const InlinePdfPreview({
    super.key,
    required this.bytes,
    this.compact = false,
    this.sourceName,
    this.onInteractionChanged,
  });

  @override
  State<InlinePdfPreview> createState() => _InlinePdfPreviewState();
}

class _InlinePdfPreviewState extends State<InlinePdfPreview> {
  static int _sourceCounter = 0;

  final PdfViewerController _controller = PdfViewerController();

  late Uint8List _data;
  late String _sourceName;

  Matrix4? _initialMatrix;
  double _baseZoom = 1.0;
  double _percent = 100;
  bool _ready = false;
  int _pageCount = 0;
  int _page = 1;

  final Set<int> _activeTouchPointers = <int>{};

  bool get _isMobileLike =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  bool get _isDesktopLike =>
      const {
        TargetPlatform.windows,
        TargetPlatform.linux,
        TargetPlatform.macOS,
      }.contains(defaultTargetPlatform);

  @override
  void initState() {
    super.initState();
    _prepareData();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant InlinePdfPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.bytes, widget.bytes) ||
        oldWidget.sourceName != widget.sourceName) {
      _ready = false;
      _initialMatrix = null;
      _prepareData();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  /// تحويل الـ bytes مرة واحدة فقط (بدون نسخ لو كانت Uint8List أصلاً).
  void _prepareData() {
    final b = widget.bytes;
    _data = b is Uint8List ? b : Uint8List.fromList(b);

    final providedSourceName = widget.sourceName?.trim();

    _sourceName =
        providedSourceName != null && providedSourceName.isNotEmpty
            ? providedSourceName
            : 'inline-pdf-${_sourceCounter++}';
  }

  bool _isTouchPointer(PointerEvent event) {
    return event.kind == PointerDeviceKind.touch ||
        event.kind == PointerDeviceKind.stylus ||
        event.kind == PointerDeviceKind.invertedStylus;
  }

  void _onPointerDown(PointerDownEvent event) {
    if (!_isMobileLike || !_isTouchPointer(event)) {
      return;
    }

    final wasEmpty = _activeTouchPointers.isEmpty;
    _activeTouchPointers.add(event.pointer);

    if (wasEmpty) {
      widget.onInteractionChanged?.call(true);
    }
  }

  void _releasePointer(PointerEvent event) {
    if (!_isMobileLike || !_isTouchPointer(event)) {
      return;
    }

    _activeTouchPointers.remove(event.pointer);

    if (_activeTouchPointers.isEmpty) {
      widget.onInteractionChanged?.call(false);
    }
  }

  void _onControllerChanged() {
    if (!_ready || !_controller.isReady) return;

    final percent = (_controller.currentZoom / _baseZoom * 100)
        .clamp(10, 1000)
        .toDouble();
    final page = _controller.pageNumber ?? _page;

    if ((percent - _percent).abs() < 0.5 && page == _page) return;

    setState(() {
      _percent = percent;
      _page = page;
    });
  }

  void _onViewerReady(PdfDocument document, PdfViewerController controller) {
    _initialMatrix = controller.value.clone();
    _baseZoom = controller.currentZoom;
    if (!mounted) return;
    setState(() {
      _ready = true;
      _pageCount = document.pages.length;
      _page = controller.pageNumber ?? 1;
      _percent = 100;
    });
  }

  void _zoomIn() => _controller.zoomUp();

  void _zoomOut() => _controller.zoomDown();

  void _resetZoom() {
    final m = _initialMatrix;
    if (m != null) _controller.goTo(m);
  }

  @override
  Widget build(BuildContext context) {
    final compact = widget.compact;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.equal, control: true): _zoomIn,
        const SingleActivator(LogicalKeyboardKey.add, control: true): _zoomIn,
        const SingleActivator(LogicalKeyboardKey.minus, control: true):
            _zoomOut,
        const SingleActivator(LogicalKeyboardKey.digit0, control: true):
            _resetZoom,
      },
      child: Focus(
        autofocus: _isDesktopLike,
        child: ColoredBox(
          color: const Color(0xFFF3F5F8),
          child: Stack(
            children: [
              Positioned.fill(
                child: Listener(
                  behavior: HitTestBehavior.translucent,
                  onPointerDown: _onPointerDown,
                  onPointerUp: _releasePointer,
                  onPointerCancel: _releasePointer,
                  child: PdfViewer.data(
                    _data,
                    sourceName: _sourceName,
                    controller: _controller,
                    params: PdfViewerParams(
                      backgroundColor: const Color(0xFFF3F5F8),
                      maxScale: 6.0,
                      margin: compact ? 6 : 12,
                      panAxis: PanAxis.aligned,
                      panEnabled: true,
                      scaleEnabled: true,
                      textSelectionParams: PdfTextSelectionParams(
                        enabled: _isDesktopLike,
                      ),
                      onViewerReady: _onViewerReady,
                      loadingBannerBuilder: (context, downloaded, total) =>
                          const Center(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.4),
                            ),
                          ),
                      errorBannerBuilder:
                          (context, error, stackTrace, source) =>
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24),
                                  child: Text(
                                    'تعذر عرض ملف الـ PDF',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF2C334A),
                                    ),
                                  ),
                                ),
                              ),
                    ),
                  ),
                ),
              ),

              // أدوات التحكم
              Positioned(
                top: compact ? 8 : 12,
                left: compact ? 8 : 12,
                child: _ZoomControls(
                  percent: _percent.round(),
                  compact: compact,
                  enabled: _ready,
                  canZoomIn: _ready && _percent < 590,
                  canZoomOut: _ready && _percent > 55,
                  canReset: _ready && (_percent - 100).abs() > 1,
                  onZoomIn: _zoomIn,
                  onZoomOut: _zoomOut,
                  onReset: _resetZoom,
                ),
              ),

              // عداد الصفحات
              if (_ready && _pageCount > 1)
                Positioned(
                  bottom: compact ? 8 : 12,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: .6),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '$_page / $_pageCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
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
// ZOOM CONTROLS
// ==========================================================

class _ZoomControls extends StatelessWidget {
  final int percent;
  final bool compact;
  final bool enabled;
  final bool canZoomIn;
  final bool canZoomOut;
  final bool canReset;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;

  const _ZoomControls({
    required this.percent,
    required this.compact,
    required this.enabled,
    required this.canZoomIn,
    required this.canZoomOut,
    required this.canReset,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .96),
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 4 : 6,
          vertical: compact ? 3 : 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ZoomButton(
              tooltip: 'تصغير',
              icon: Icons.remove_rounded,
              enabled: canZoomOut,
              compact: compact,
              onPressed: onZoomOut,
            ),
            InkWell(
              onTap: enabled ? onReset : null,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 6 : 9,
                  vertical: compact ? 5 : 7,
                ),
                child: Text(
                  '$percent%',
                  style: TextStyle(
                    color: const Color(0xFF2C334A),
                    fontSize: compact ? 10 : 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            _ZoomButton(
              tooltip: 'تكبير',
              icon: Icons.add_rounded,
              enabled: canZoomIn,
              compact: compact,
              onPressed: onZoomIn,
            ),
            if (!compact) ...[
              const SizedBox(width: 3),
              _ZoomButton(
                tooltip: 'الحجم الطبيعي',
                icon: Icons.restart_alt_rounded,
                enabled: canReset,
                compact: compact,
                onPressed: onReset,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final bool enabled;
  final bool compact;
  final VoidCallback onPressed;

  const _ZoomButton({
    required this.tooltip,
    required this.icon,
    required this.enabled,
    required this.compact,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: enabled ? onPressed : null,
        constraints: BoxConstraints.tightFor(
          width: compact ? 30 : 34,
          height: compact ? 30 : 34,
        ),
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        icon: Icon(icon, size: compact ? 17 : 19),
      ),
    );
  }
}
