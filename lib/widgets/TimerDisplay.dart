import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stagecon/widgets/TimeDisplay.dart';

enum TimerDisplayMode {
  countdown,
  stopwatch
}

class TimerDisplayController {
  TimerDisplayController({
    required Duration startingAt,
    bool running = false,
    TimerDisplayMode mode = TimerDisplayMode.countdown,
    Color countdownColor = Colors.grey 
  }) {
      //preferences
      final pref = Hive.box("preferences");

      this._running = running;
      this._mode = mode;
      this._startingAt = startingAt;
      this._countdownColor = countdownColor;
      this._msPrecision = pref.get("default_ms_precision");
      this._flashRate = pref.get("default_countdown_flash_rate");
  }

  late Color _countdownColor;
  set countdownColor(Color v) => _update("countdownColor", () {
    _countdownColor = v;
  });
  Color get countdownColor => _countdownColor;

  late bool _running;
  ///sets if the timer is running or paused 
  set running(bool v) => _update("running", (){
    _running = v;
  });
  bool get running => _running;

  late TimerDisplayMode _mode;
  ///Sets the timer mode 
  set mode(TimerDisplayMode v) => _update("mode",() {
    _mode  = v;
  });
  TimerDisplayMode get mode => _mode;

  late Duration _startingAt;
  ///Sets the starting time for the timer clock
  set startingAt(Duration v) => _update("startingAt",(){
    _startingAt = v;
  });
  Duration get startingAt => _startingAt;

  late int _msPrecision;
  set msPrecision(int v) => _update("msPrecision", () {
    _msPrecision = v;
  });
  int get msPrecision => _msPrecision;
  
  late int _flashRate;
  set flashRate(int v) => _update("flashRate", () {
    _flashRate = v;
  });
  int get flashRate => _flashRate;

  // reset

  reset() {
    if(running) {
      running = false;
      _update("startingAt",(){});
      running = true;
    } else {
      _update("startingAt",(){});
    }
    
  }


  //event listeners
  Set<Function(String changed)> _listeners = {};
  addListener(Function(String changed) listener) {
    _listeners.add(listener);
  }
  removeListener(Function(String changed) listener) {
    _listeners.remove(listener);
  }

  /// called when anything changes within this function
  _update(String changed, Function cb) {
    cb();
    // print(_listeners);
    //call each event listener
    _listeners.forEach((element) => element(changed));
  }

}


class TimerDisplay extends StatefulWidget {
  ///If [mode] is stopwatch then [startingAt] will be the starting time and it will count up from there. if [mode] is countdown then  it will start counting down from [startingAt]
  const TimerDisplay({
    Key? key,
    required this.controller,
    // this.countdownColor= Colors.grey,
  }) : super(key: key);

  final TimerDisplayController controller;
  // final Color countdownColor;

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay> {
  Duration currentDuration = Duration.zero;

  late Timer _timer;
  late Timer _flashTimer;
  DateTime? _startTime;

  late Color countdownColor = widget.controller.countdownColor;

  // late bool isRunning = widget.controller.running;
  late Duration startingAt = widget.controller.startingAt;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 8), (_) => handleTick());
    _timer.cancel();
    _flashTimer = Timer.periodic(const Duration(seconds: 1), (_) => handleDoneFlash());
    _flashTimer.cancel();
    
    widget.controller.addListener(controllerUpdated);
    currentDuration = widget.controller.startingAt;
    if(widget.controller.running) {
      start();

    }
    
    super.initState();
  }
  

  controllerUpdated(String changed) {
    // print(widget.controller.mode);
    if(changed  == "startingAt") {
      print("diff");
      currentDuration = widget.controller.startingAt;
      startingAt = widget.controller.startingAt;
      // start();
    }

    if(changed == "running") {
      // isRunning = widget.controller.running;
      if(!widget.controller.running) {
        //we need to pause
        _timer.cancel();
        _flashTimer.cancel();
        startingAt = currentDuration;
        
      } else {
        //we need to play
        start(); 
      }
    }
    // if(isRunning != widget.controller.running) {
    //   if(widget.controller.running = false) {
    //     //we are pauseing
    //     startingAt = currentDuration;
    //   }
    // }
    if(mounted) {
      setState(() {
      
    });
    }
  }

  void handleTick() {
    // print("hey");
    if (widget.controller.running) {
      if(mounted) {
        setState(() {
        if (widget.controller.mode == TimerDisplayMode.stopwatch) {
          currentDuration = DateTime.now().difference(_startTime!);
        } else {
          currentDuration =
              startingAt - DateTime.now().difference(_startTime!);
          if (currentDuration.isNegative) {
            currentDuration = Duration.zero;
            _timer.cancel();
            widget.controller._running= false;
            countdownDoneFlash();
            // _startTime = DateTime.now();
            // currentDuration = Duration.zero;
            
          }
        }
      });
      }
    }
  }

  start() {
    // _startTime = DateTime.now().subtract(startingAt);
    if (widget.controller.mode == TimerDisplayMode.stopwatch) {
      _startTime = DateTime.now().subtract(startingAt);
    } else {
      _startTime = DateTime.now();
    }
    countdownColor = widget.controller.countdownColor;
    _timer.cancel();
    _flashTimer.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 8), (_) => handleTick());
  }

  //flashes the countdown clock when it reaches 0;
  countdownDoneFlash() {
    _flashTimer.cancel();
    _flashTimer = Timer.periodic(Duration(milliseconds: widget.controller.flashRate), (_) => handleDoneFlash());
  }

  handleDoneFlash() {
    if(mounted) {
      setState(() {
      countdownColor = countdownColor==widget.controller.countdownColor?Colors.transparent:widget.controller.countdownColor;
    });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    widget.controller.removeListener(controllerUpdated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        //MARK: Countdown bar
        if(widget.controller.mode == TimerDisplayMode.countdown )Positioned.fill(left: 0, child: FractionallySizedBox(widthFactor: 1 -(currentDuration.inMilliseconds/widget.controller.startingAt.inMilliseconds), child: Container(color: countdownColor))),


        Positioned(child: TimeDisplay(duration: currentDuration, mode: TimeDisplayMode.h24, msPrecision: widget.controller.msPrecision,))
      ],

    );
  
    
  }
}