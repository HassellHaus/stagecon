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
class TimerDisplayController {
  TimerDisplayController({
    required Duration startingAt,
    bool running = true,
    TimerDisplayMode mode = TimerDisplayMode.countdown
  }) {
      this._running = running;
      this._mode = mode;
      this._startingAt = startingAt;
  }

  
  late bool _running;
  ///sets if the timer is running or paused 
  set running(bool v) => _update((){
    _running = v;
  });
  bool get running => _running;

  late TimerDisplayMode _mode;
  ///Sets the timer mode 
  set mode(TimerDisplayMode v) => _update(() {
    _mode  = v;
  });
  TimerDisplayMode get mode => _mode;

  late Duration _startingAt;
  ///Sets the starting time for the timer clock
  set startingAt(Duration v) => _update((){
    _startingAt = v;
  });
  Duration get startingAt => _startingAt;

  //event listeners
  Set<Function> _listeners = {};
  addListener(Function listener) {
    _listeners.add(listener);
  }
  removeListener(Function listener) {
    _listeners.remove(listener);
  }

  /// called when anything changes within this function
  _update(Function cb) {
    cb();
    //call each event listener
    _listeners.forEach((element) => element());
  }

}


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

            // _startTime = DateTime.now();
            // currentDuration = Duration.zero;
            
          }
        }
      });
    }
  }

  start() {
    currentDuration = widget.startingAt;
    if (widget.mode == TimerDisplayMode.stopwatch) {
      _startTime = DateTime.now().subtract(widget.startingAt);
    } else {
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
        // if(widget.mode == TimerDisplayMode.countdown )Positioned.fill(left: 0, child: FractionallySizedBox(widthFactor: , child: Container(color: widget.backgroundColor))),
        Positioned(child: TimeDisplay(duration: currentDuration, mode: TimeDisplayMode.h24,))
      ],

    );
  
    
  }
}