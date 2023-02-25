import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stagecon/widgets/TimeDisplay.dart';

enum TimerDisplayMode {
  countdown,
  stopwatch
}

// enum TimerDisplayState {
//   stopped,
//   running
// }

class TimerDisplay extends StatefulWidget {
  ///If [mode] is stopwatch then [startingAt] will be the starting time and it will count up from there. if [mode] is countdown then  it will start counting down from [startingAt]
  TimerDisplay({
    Key? key,
    this.mode = TimerDisplayMode.stopwatch,
    required this.startingAt,
    this.running = true,
    this.backgroundColor= Colors.grey,
  }) : super(key: key);

  final TimerDisplayMode mode;
  final Duration startingAt;
  final bool running;
  final Color backgroundColor;

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay> {
  late Duration currentDuration;

  late Timer _timer;
  DateTime? _startTime;

  late bool isRunning = widget.running;

  @override
  void initState() {
    start();
    _timer = Timer.periodic(Duration(milliseconds: 8), (_) => handleTick());
    super.initState();
  }

  void handleTick() {
    if (widget.running) {
      setState(() {
        if (widget.mode == TimerDisplayMode.stopwatch) {
          currentDuration = DateTime.now().difference(_startTime!);
        } else {
          currentDuration =
              widget.startingAt - DateTime.now().difference(_startTime!);
          if (currentDuration.isNegative) {
            currentDuration = Duration.zero;
            _timer.cancel();
          }
        }
      });
    }
  }

  start() {
    currentDuration = widget.startingAt;
    if (widget.mode == TimerDisplayMode.stopwatch) {
      _startTime = DateTime.now();
    }
  }

  // void toggleRunning() {
  //   setState(() {
  //     widget.running = !widget.running;
  //   });
  // }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(isRunning == false && widget.running == true) {
      isRunning = widget.running;
      start();
    } else {
      isRunning = widget.running;
    }
    return Stack(
      children: [
        // Positioned.fill(left: 0, child: FractionallySizedBox(widthFactor: 0.2, child: Container(color: widget.backgroundColor))),
        Positioned(child: TimeDisplay(duration: currentDuration, mode: TimeDisplayMode.h24,))
      ],

    );
  
    
  }
}