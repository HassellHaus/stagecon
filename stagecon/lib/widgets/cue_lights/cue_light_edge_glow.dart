import 'dart:math';

import 'package:flutter/cupertino.dart';
// import 'dart:' as math;

class RotatingBorderWidget extends StatefulWidget {
  final List<Color> colors;
  final Duration duration;

  RotatingBorderWidget({super.key, required this.colors, this.duration= const Duration(seconds: 5)});

  @override
  _RotatingBorderWidgetState createState() => _RotatingBorderWidgetState();
}

class _RotatingBorderWidgetState extends State<RotatingBorderWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
    _animation = Tween(begin: 0.0, end: 360.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: BorderPainter(_animation.value, widget.colors),
          child: Container(
            width: 200,
            height: 200,
          ),
        );
      },
    );
  }
}

class BorderPainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  BorderPainter(this.angle, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

    for (var i = 0; i < colors.length; i++) {
      paint.shader = SweepGradient(
        colors: [colors[i], colors[(i + 1) % colors.length]],
        startAngle: _degreesToRadians(angle + i * (360 / colors.length)),
        endAngle: _degreesToRadians(angle + (i + 1) * (360 / colors.length)),
        tileMode: TileMode.repeated,
      ).createShader(rect);

      canvas.drawArc(rect, _degreesToRadians(angle + i * (360 / colors.length)),
          _degreesToRadians(360 / colors.length), false, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
