import 'package:flutter/material.dart';

/// Horizontal scroll area with an optional always-visible scrollbar thumb.
class HorizontalScrollWithThumb extends StatefulWidget {
  const HorizontalScrollWithThumb({
    super.key,
    required this.thumbVisibility,
    required this.child,
    this.padding,
  });

  final bool thumbVisibility;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  State<HorizontalScrollWithThumb> createState() =>
      _HorizontalScrollWithThumbState();
}

class _HorizontalScrollWithThumbState extends State<HorizontalScrollWithThumb> {
  late final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _controller,
      thumbVisibility: widget.thumbVisibility,
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }
}
