import 'package:flutter/widgets.dart';

/// Modern premium custom scrollbar with interactive cursor pointer, drag support and paint boundary isolation.
class TerminalCatalogScrollbar extends StatefulWidget {
  final ScrollController controller;
  final Widget child;

  const TerminalCatalogScrollbar({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  State<TerminalCatalogScrollbar> createState() =>
      _TerminalCatalogScrollbarState();
}

class _TerminalCatalogScrollbarState extends State<TerminalCatalogScrollbar> {
  bool _isHovered = false;
  bool _isDragging = false;

  void _onVerticalDragUpdate(DragUpdateDetails details, double trackHeight) {
    if (!widget.controller.hasClients ||
        !widget.controller.position.hasContentDimensions) {
      return;
    }
    final maxScroll = widget.controller.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    final thumbHeight = _calculateThumbHeight(trackHeight);
    final scrollableTrack = trackHeight - thumbHeight;
    if (scrollableTrack <= 0) return;

    final delta = (details.delta.dy / scrollableTrack) * maxScroll;
    final newOffset = (widget.controller.offset + delta).clamp(0.0, maxScroll);
    widget.controller.jumpTo(newOffset);
  }

  double _calculateThumbHeight(double trackHeight) {
    if (!widget.controller.hasClients ||
        !widget.controller.position.hasContentDimensions ||
        trackHeight <= 0) {
      return 0.0;
    }
    final position = widget.controller.position;
    final viewport = position.viewportDimension;
    final maxScroll = position.maxScrollExtent;
    if (maxScroll <= 0 || viewport <= 0) return trackHeight;
    final ratio = viewport / (maxScroll + viewport);
    final minHeight = 40.0.clamp(0.0, trackHeight);
    return (trackHeight * ratio).clamp(minHeight, trackHeight);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.maxHeight.isFinite || constraints.maxHeight <= 16) {
          return widget.child;
        }

        final trackHeight = constraints.maxHeight - 16;

        return Stack(
          children: [
            widget.child,
            Positioned(
              top: 8,
              right: 1,
              bottom: 8,
              width: 12,
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: widget.controller,
                  builder: (context, _) {
                    if (!widget.controller.hasClients ||
                        widget.controller.positions.length != 1 ||
                        !widget.controller.position.hasContentDimensions) {
                      return const SizedBox.shrink();
                    }

                    final position = widget.controller.position;
                    final maxScroll = position.maxScrollExtent;
                    if (maxScroll <= 0) return const SizedBox.shrink();

                    final thumbHeight = _calculateThumbHeight(trackHeight);
                    final scrollableTrack = trackHeight - thumbHeight;
                    final progress = (position.pixels / maxScroll).clamp(
                      0.0,
                      1.0,
                    );
                    final topOffset = progress * scrollableTrack;

                    final isActive = _isHovered || _isDragging;

                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => _isHovered = true),
                      onExit: (_) => setState(() => _isHovered = false),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragStart: (_) =>
                            setState(() => _isDragging = true),
                        onVerticalDragEnd: (_) =>
                            setState(() => _isDragging = false),
                        onVerticalDragCancel: () =>
                            setState(() => _isDragging = false),
                        onVerticalDragUpdate: (details) =>
                            _onVerticalDragUpdate(details, trackHeight),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Positioned(
                              top: topOffset,
                              right: 0,
                              width: 5,
                              height: thumbHeight,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? const Color(0xFF0F172A)
                                      : const Color(0x590F172A),
                                  borderRadius: BorderRadius.circular(999),
                                ),
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
          ],
        );
      },
    );
  }
}
