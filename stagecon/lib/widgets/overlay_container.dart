import 'package:flutter/cupertino.dart';
import 'package:flutter_portal/flutter_portal.dart';

class OverlayContainer extends StatefulWidget {
  const OverlayContainer({super.key, required this.buttonBuilder, required this.overlayBuilder, required this.anchor, this.duration = const Duration(milliseconds: 300)});

  final Widget Function(BuildContext context, void Function() toggleOverlay) buttonBuilder;
  final Widget Function(BuildContext context, double duration) overlayBuilder;
  final Anchor anchor;
  final Duration duration;

  @override
  State<OverlayContainer> createState() => _OverlayContainerState();
}

class _OverlayContainerState extends State<OverlayContainer> with TickerProviderStateMixin {
  bool _visible = false;

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleOverlay() {
    setState(() {
      _visible = !_visible;
      if (_visible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      closeDuration: widget.duration,
      visible: _visible,
      anchor: widget.anchor,
      portalFollower: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return widget.overlayBuilder(context, _controller.value);
        },
      ),
      child: widget.buttonBuilder(context, toggleOverlay),
      
    );
  }
}
