import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

/// عارض PDF من bytes تم تحميلها مسبقاً عن طريق Dio.
///
/// السلوك:
///
/// Desktop / Web:
/// - عجلة الماوس تعمل Scroll عادي داخل الـ PDF.
/// - التكبير والتصغير من أزرار + و - فقط.
/// - عجلة الماوس لا تعمل Zoom.
/// - بعد التكبير يمكن سحب الـ PDF يمين / شمال / فوق / تحت.
///
/// Mobile:
/// - Scroll عادي بإصبع واحد عند 100%.
/// - Pinch Zoom بإصبعين.
/// - التكبير والتصغير من أزرار + و -.
/// - بعد التكبير يمكن سحب الجزء المكبر.
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
  static const double _minScale = 1.0;
  static const double _maxScale = 4.0;
  static const double _scaleStep = 0.25;

  final TransformationController
  _transformationController =
  TransformationController();

  double _scale = 1.0;

  bool get _isZoomed =>
      _scale > 1.01;

  bool get _isTouchPlatform {
    return defaultTargetPlatform ==
        TargetPlatform.android ||
        defaultTargetPlatform ==
            TargetPlatform.iOS;
  }

  @override
  void initState() {
    super.initState();

    _transformationController
        .addListener(
      _onTransformChanged,
    );
  }

  @override
  void dispose() {
    _transformationController
        .removeListener(
      _onTransformChanged,
    );

    _transformationController
        .dispose();

    super.dispose();
  }

  // =========================================================
  // TRANSFORM CHANGE
  // =========================================================

  void _onTransformChanged() {
    final newScale =
    _transformationController
        .value
        .getMaxScaleOnAxis()
        .clamp(
      _minScale,
      _maxScale,
    )
        .toDouble();

    if ((newScale - _scale).abs() <
        .01) {
      return;
    }

    setState(() {
      _scale = newScale;
    });
  }

  // =========================================================
  // SET SCALE
  // =========================================================

  void _setScale(
      double value,
      ) {
    final nextScale =
    value
        .clamp(
      _minScale,
      _maxScale,
    )
        .toDouble();

    _transformationController
        .value =
        Matrix4.diagonal3Values(
          nextScale,
          nextScale,
          1,
        );
  }

  // =========================================================
  // ZOOM IN
  // =========================================================

  void _zoomIn() {
    _setScale(
      _scale + _scaleStep,
    );
  }

  // =========================================================
  // ZOOM OUT
  // =========================================================

  void _zoomOut() {
    _setScale(
      _scale - _scaleStep,
    );
  }

  // =========================================================
  // RESET ZOOM
  // =========================================================

  void _resetZoom() {
    _transformationController
        .value =
        Matrix4.identity();
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    final pdfBytes =
    Uint8List.fromList(
      widget.bytes,
    );

    final touchZoomEnabled =
        _isTouchPlatform;

    return ColoredBox(
      color: const Color(
        0xFFF3F5F8,
      ),
      child: Stack(
        children: [
          // ===============================================
          // PDF VIEWER
          // ===============================================

          Positioned.fill(
            child: InteractiveViewer(
              transformationController:
              _transformationController,

              minScale: _minScale,
              maxScale: _maxScale,

              // ===========================================
              // PINCH ZOOM
              // ===========================================
              //
              // على الهاتف:
              // التكبير بإصبعين شغال.
              //
              // على الكمبيوتر:
              // الـ Mouse Wheel لا يعمل Zoom.
              // التكبير فقط من + و -.

              scaleEnabled:
              touchZoomEnabled,

              // يمنع الـ Trackpad / Mouse Wheel
              // من التحول إلى Zoom.

              trackpadScrollCausesScale:
              false,

              // ===========================================
              // PAN
              // ===========================================
              //
              // عند 100%:
              // الـ PDF يعمل Scroll طبيعي.
              //
              // بعد التكبير:
              // يمكن سحب الصفحة في كل الاتجاهات
              // سواء بالماوس أو اللمس.

              panEnabled:
              _isZoomed,

              boundaryMargin:
              const EdgeInsets.all(
                200,
              ),

              clipBehavior:
              Clip.hardEdge,

              child: PdfPreview(
                build: (_) async =>
                pdfBytes,

                initialPageFormat:
                PdfPageFormat.a4,

                canChangeOrientation:
                false,

                canChangePageFormat:
                false,

                canDebug:
                false,

                allowPrinting:
                false,

                allowSharing:
                false,

                useActions:
                false,

                maxPageWidth:
                widget.compact
                    ? 640
                    : 1100,

                loadingWidget:
                const Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child:
                    CircularProgressIndicator(
                      strokeWidth:
                      2.4,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ===============================================
          // ZOOM CONTROLS
          // ===============================================

          Positioned(
            top:
            widget.compact
                ? 8
                : 12,
            left:
            widget.compact
                ? 8
                : 12,
            child: _ZoomControls(
              scale:
              _scale,

              compact:
              widget.compact,

              canZoomIn:
              _scale <
                  _maxScale -
                      .01,

              canZoomOut:
              _scale >
                  _minScale +
                      .01,

              onZoomIn:
              _zoomIn,

              onZoomOut:
              _zoomOut,

              onReset:
              _resetZoom,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// ZOOM CONTROLS
// ==========================================================

class _ZoomControls
    extends StatelessWidget {
  final double scale;
  final bool compact;

  final bool canZoomIn;
  final bool canZoomOut;

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;

  const _ZoomControls({
    required this.scale,
    required this.compact,
    required this.canZoomIn,
    required this.canZoomOut,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    final percentage =
    (scale * 100).round();

    return Material(
      color:
      Colors.white.withValues(
        alpha: .96,
      ),

      elevation: 4,

      borderRadius:
      BorderRadius.circular(
        12,
      ),

      child: Container(
        padding:
        EdgeInsets.symmetric(
          horizontal:
          compact ? 4 : 6,
          vertical:
          compact ? 3 : 5,
        ),

        decoration:
        BoxDecoration(
          borderRadius:
          BorderRadius.circular(
            12,
          ),

          border: Border.all(
            color: const Color(
              0xFFE5E7EB,
            ),
          ),
        ),

        child: Row(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            // =============================================
            // ZOOM OUT
            // =============================================

            _ZoomButton(
              tooltip:
              'تصغير',

              icon:
              Icons.remove_rounded,

              enabled:
              canZoomOut,

              compact:
              compact,

              onPressed:
              onZoomOut,
            ),

            // =============================================
            // SCALE PERCENTAGE
            // =============================================

            InkWell(
              onTap:
              onReset,

              borderRadius:
              BorderRadius.circular(
                8,
              ),

              child: Padding(
                padding:
                EdgeInsets.symmetric(
                  horizontal:
                  compact
                      ? 6
                      : 9,

                  vertical:
                  compact
                      ? 5
                      : 7,
                ),

                child: Text(
                  '$percentage%',

                  style:
                  TextStyle(
                    color:
                    const Color(
                      0xFF2C334A,
                    ),

                    fontSize:
                    compact
                        ? 10
                        : 11,

                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ),
            ),

            // =============================================
            // ZOOM IN
            // =============================================

            _ZoomButton(
              tooltip:
              'تكبير',

              icon:
              Icons.add_rounded,

              enabled:
              canZoomIn,

              compact:
              compact,

              onPressed:
              onZoomIn,
            ),

            // =============================================
            // RESET
            // =============================================

            if (!compact) ...[
              const SizedBox(
                width: 3,
              ),

              _ZoomButton(
                tooltip:
                'الحجم الطبيعي',

                icon:
                Icons
                    .restart_alt_rounded,

                enabled:
                scale > 1.01,

                compact:
                compact,

                onPressed:
                onReset,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// ZOOM BUTTON
// ==========================================================

class _ZoomButton
    extends StatelessWidget {
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
  Widget build(
      BuildContext context,
      ) {
    return Tooltip(
      message:
      tooltip,

      child: IconButton(
        onPressed:
        enabled
            ? onPressed
            : null,

        constraints:
        BoxConstraints.tightFor(
          width:
          compact
              ? 30
              : 34,

          height:
          compact
              ? 30
              : 34,
        ),

        padding:
        EdgeInsets.zero,

        visualDensity:
        VisualDensity.compact,

        icon: Icon(
          icon,

          size:
          compact
              ? 17
              : 19,
        ),
      ),
    );
  }
}