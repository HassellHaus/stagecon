
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:stagecon/types/sc_cuelight.dart';



class CueLightBulb extends StatefulWidget {
  const CueLightBulb({super.key, required this.color, this.state = CueLightState.inactive});
  final Color color;

  final CueLightState state;

  // final bool enabled;

  @override
  State<CueLightBulb> createState() => _CueLightBulbState();
}

// class _CueLightBulbState extends State<CueLightBulb> {

  

//   late Color offColor;

//   Color get currentColor => widget.color;


//   @override
//   void initState() {
//     offColor = HSLColor.fromColor(widget.color).withSaturation(0.3).toColor();
//     super.initState();
//   }

//   void tapped() {

//   }



//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//         decoration: BoxDecoration(
//           // color: widget.inverse ? offColor : currentColor,
//           borderRadius: BorderRadius.circular(100),
//           border: Border.all(color: widget.state==CueLightState.active ? currentColor : offColor, width: 10),
//           boxShadow: widget.state!=CueLightState.active ?null: [
//             BoxShadow(
//               color: currentColor,
//               blurRadius: 10,
//               spreadRadius: 1,
//               offset: Offset(0, 0),
//             )
//           ]
//         ),
    
//         child: FractionallySizedBox(
//           widthFactor: 0.8,
//           heightFactor: 0.8,
//           child: Center(child: Container(
//             decoration: BoxDecoration(
//               color: widget.state==CueLightState.active ? currentColor : offColor,
//               borderRadius: BorderRadius.circular(100),
//             ),
//           )),
//         ),
        
      
//     );
//   }
// }


class _CueLightBulbState extends State<CueLightBulb> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Color offColor;

  Color getOffColor() {
    return HSLColor.fromColor(widget.color).withSaturation(
      widget.state == CueLightState.standby ? 0.1:0.3
    ).toColor();
  }

  @override
  void initState() {
    super.initState();
    offColor = getOffColor();

    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    if(CueLightState.standby == widget.state) {
      // _controller.s
      _controller.repeat();
    }
  }

@override
  void didUpdateWidget(covariant CueLightBulb oldWidget) {
    offColor = getOffColor();
    if(CueLightState.standby == widget.state) {
      // _controller.s
      _controller.repeat();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: widget.state == CueLightState.active ? widget.color : const Color(0x00000000),
            border: Border.all(color: widget.state==CueLightState.active ? widget.color : offColor, width: 10),
            borderRadius: BorderRadius.circular(100),
            boxShadow: widget.state != CueLightState.active ? null : [
              BoxShadow(
                color: widget.color,
                blurRadius: 20,
                spreadRadius: 5,
                offset: Offset(0, 0),
              )
            ],
          ),
          child: CustomPaint(
            painter: BorderPainter(
              // enabled: widget.state==CueLightState.standby, 
              color: widget.state==CueLightState.standby? widget.color: const Color(0x00000000),
              percentage: 0.20, // Adjust this value for the length of the border shown
              rotation: _controller.value * 2 * pi, // Full rotation
            ),
            child: FractionallySizedBox(
              widthFactor: 0.8,
              heightFactor: 0.8,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.state == CueLightState.active ? widget.color : offColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class BorderPainter extends CustomPainter {
  final Color color;
  final double percentage;
  final double rotation;

  BorderPainter({required this.color, required this.percentage, required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
      
      // ..imageFilter = ImageFilter.blur(sigmaX: 2, sigmaY: 2);

    final rect = Offset.zero & size;
    final startAngle = rotation;
    final sweepAngle = 2 * pi * percentage;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
