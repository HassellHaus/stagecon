// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:stagecon/types/sc_timer.dart';
// import 'package:stagecon/widgets/ClockDisplay.dart';

// class TimerDisplay extends StatefulWidget {
//   const TimerDisplay({
//     Key? key,
//     required this.scTimer,
//   }) : super(key: key);
//   final ScTimer scTimer;

//   @override
//   State<TimerDisplay> createState() => _TimerDisplayState();
// }

// class _TimerDisplayState extends State<TimerDisplay> {
//   Duration currentDuration = Duration.zero;
//   late Timer _timer;
//   late Timer _flashTimer;

//   late DateTime? _startTime;

//   // Assuming that 'preferences' box and "default_ms_precision" exist in your Hive DB
//   int defaultMsPrecision = Hive.box('preferences').get("default_ms_precision", defaultValue: 1);
//   int defaultFlashRate = Hive.box('preferences').get("default_countdown_flash_rate", defaultValue: 500);

//   late Color countdownColor;

//   // Initialize resources
//   @override
//   void initState() {
//     super.initState();
//     _initTimers();
//     currentDuration = widget.scTimer.startingAt;
//     countdownColor = widget.scTimer.color;
//     // _startTimer();
//     _loadCurrentDuration();

//   }

//   // Initialize timers
//   void _initTimers() {
//     _timer = Timer.periodic(const Duration(milliseconds: 8), (_) => _handleTick());
//     _timer.cancel();
//     _flashTimer = Timer.periodic(const Duration(seconds: 1), (_) => _handleDoneFlash());
//     _flashTimer.cancel();
//   }

//     // Called whenever the widget configuration changes (e.g., the parent rebuilds it)
//   @override
//   void didUpdateWidget(covariant TimerDisplay oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _loadCurrentDuration();
//     // print("Checking if we need to update: ${widget.scTimer.id}");

//     setState(() {
//         // Update local state with new ScTimer properties
//         currentDuration = widget.scTimer.startingAt;
//         countdownColor = widget.scTimer.color;

//         // Start or stop the timer based on ScTimer state
//         if (widget.scTimer.running) {
//           _startTimer();
//         } else {
//           _timer.cancel();
//           _flashTimer.cancel();
//         }
//       });

//     // Check if any relevant fields have changed
//     // if (

//     //     oldWidget.scTimer.flashRate != widget.scTimer.flashRate ||
//     //     oldWidget.scTimer.mode != widget.scTimer.mode ||
//     //     oldWidget.scTimer.msPrecision != widget.scTimer.msPrecision ||
//     //     oldWidget.scTimer.createdAt != widget.scTimer.createdAt ||
//     //     oldWidget.scTimer.startingAt != widget.scTimer.startingAt ||
//     //     oldWidget.scTimer.running != widget.scTimer.running ||
//     //     oldWidget.scTimer.color != widget.scTimer.color) {
//     //     print("updating timer: ${widget.scTimer.id}");
//     //   setState(() {
//     //     // Update local state with new ScTimer properties
//     //     currentDuration = widget.scTimer.startingAt;
//     //     countdownColor = widget.scTimer.color;

//     //     // Start or stop the timer based on ScTimer state
//     //     if (widget.scTimer.running) {
//     //       _startTimer();
//     //     } else {
//     //       _timer.cancel();
//     //       _flashTimer.cancel();
//     //     }
//     //   });
//     // }
//   }

//   // Handle timer ticks
//   void _handleTick() {
//     if (widget.scTimer.running) {
//       setState(() {
//         // Assuming scTimer has a mode property
//         if (widget.scTimer.mode == TimerMode.stopwatch) {
//           currentDuration = DateTime.now().difference(_startTime!);
//         } else {
//           currentDuration = widget.scTimer.startingAt - DateTime.now().difference(_startTime!);
//           if (currentDuration.isNegative) {
//             currentDuration = Duration.zero;
//             _timer.cancel();
//             widget.scTimer.running = false;
//             _countdownDoneFlash();
//           }
//         }
//       });
//     }
//   }

//   void _loadCurrentDuration() {
//      if (widget.scTimer.mode == TimerMode.stopwatch) {
//       _startTime = widget.scTimer.createdAt.subtract(widget.scTimer.startingAt);
//     } else {
//       _startTime = widget.scTimer.createdAt;
//     }

//     //load in the current duration regardless of if the timer is running or not ensuring that the timer is accurate using widget.scTimer.createdAt as epoch time
//     if (widget.scTimer.mode == TimerMode.stopwatch) {
//       //! this is broken  we need to somehow keep track of when the timer was started (while also supporting pausing and resuming)
//       currentDuration = DateTime.now().difference(_startTime!);
//     } else {
//       currentDuration = widget.scTimer.startingAt - DateTime.now().difference(_startTime!);
//       if (currentDuration.isNegative) {
//         currentDuration = Duration.zero;
//         _timer.cancel();
//         widget.scTimer.running = false;
//         _countdownDoneFlash();
//       }
//     }

//     // _handleTick();
//   }

//   // Start the timer
//   void _startTimer() {
//     _loadCurrentDuration();
//     // _startTime = DateTime.now();//.add(widget.scTimer.startingAt);
//     print(DateTime.now());
//     print(_startTime);
//     _timer.cancel();
//     _flashTimer.cancel();
//     _timer = Timer.periodic(const Duration(milliseconds: 8), (_) => _handleTick());
//   }

//   // Flash the countdown clock when it reaches 0
//   void _countdownDoneFlash() {
//     _flashTimer.cancel();
//     _flashTimer = Timer.periodic(Duration(milliseconds: widget.scTimer.flashRate ?? defaultFlashRate), (_) => _handleDoneFlash());
//   }

//   // Handle the flashing
//   void _handleDoneFlash() {
//     setState(() {
//       countdownColor = countdownColor == widget.scTimer.color ? Colors.transparent : widget.scTimer.color;
//     });
//   }

//   // Dispose resources
//   @override
//   void dispose() {
//     _timer.cancel();
//     _flashTimer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return
//     // Column(children: [
//     //   //title / id

//     //   FittedBox(
//     //     fit: BoxFit.scaleDown,
//     //     child: Text(widget.scTimer.id)),

//       //timer
//       Stack(
//         children: [
//           // Countdown bar
//           if (widget.scTimer.mode == TimerMode.countdown)
//             Positioned.fill(
//               left: 0,
//               child: FractionallySizedBox(
//                 widthFactor: 1 - (currentDuration.inMilliseconds / widget.scTimer.startingAt.inMilliseconds),
//                 child: Container(color: countdownColor.withOpacity(0.4)),
//               ),
//             ),
//           Positioned(
//             child: ClockDisplay(
//               duration: currentDuration,
//               mode: ClockDisplayMode.h24,
//               msPrecision: widget.scTimer.msPrecision ?? defaultMsPrecision,
//             ),
//           ),
//         ],
//       );
//     // ],);

//   }
// }

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stagecon/types/sc_timer.dart';
import 'package:stagecon/widgets/ClockDisplay.dart';

class TimerDisplay extends StatefulWidget {
  const TimerDisplay({
    Key? key,
    required this.scTimer,
  }) : super(key: key);
  final ScTimer scTimer;

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay> {
  late Timer _timer;
  late Timer _flashTimer;

  // Assuming that 'preferences' box and "default_ms_precision" exist in your Hive DB
  int defaultMsPrecision = Hive.box('preferences').get("default_ms_precision", defaultValue: 1);
  int defaultFlashRate = Hive.box('preferences').get("default_countdown_flash_rate", defaultValue: 500);

  late Color countdownColor;

  // Initialize resources
  @override
  void initState() {
    super.initState();
    _initTimers();
    countdownColor = widget.scTimer.color;
    // _startTimer();
    // _loadCurrentDuration();
  }

  // Initialize timers
  void _initTimers() {
    _timer = Timer.periodic(const Duration(milliseconds: 8), (_) => _handleTick());
    _flashTimer = Timer.periodic(const Duration(seconds: 1), (_) => _handleDoneFlash());
    if (widget.scTimer.running) {
      _startTimer();
    } else {
      _timer.cancel();
      _flashTimer.cancel();
    }
  }

  // Called whenever the widget configuration changes (e.g., the parent rebuilds it)
  @override
  void didUpdateWidget(covariant TimerDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // _loadCurrentDuration();
    // print("Checking if we need to update: ${widget.scTimer.id}");

    setState(() {
      // Update local state with new ScTimer properties
      // currentDuration = widget.scTimer.startingAt;
      countdownColor = widget.scTimer.color;

      // Start or stop the timer based on ScTimer state
      if (widget.scTimer.running) {
        _startTimer();
      } else {
        _timer.cancel();
        _flashTimer.cancel();
      }
    });

    // Check if any relevant fields have changed
    // if (

    //     oldWidget.scTimer.flashRate != widget.scTimer.flashRate ||
    //     oldWidget.scTimer.mode != widget.scTimer.mode ||
    //     oldWidget.scTimer.msPrecision != widget.scTimer.msPrecision ||
    //     oldWidget.scTimer.createdAt != widget.scTimer.createdAt ||
    //     oldWidget.scTimer.startingAt != widget.scTimer.startingAt ||
    //     oldWidget.scTimer.running != widget.scTimer.running ||
    //     oldWidget.scTimer.color != widget.scTimer.color) {
    //     print("updating timer: ${widget.scTimer.id}");
    //   setState(() {
    //     // Update local state with new ScTimer properties
    //     currentDuration = widget.scTimer.startingAt;
    //     countdownColor = widget.scTimer.color;

    //     // Start or stop the timer based on ScTimer state
    //     if (widget.scTimer.running) {
    //       _startTimer();
    //     } else {
    //       _timer.cancel();
    //       _flashTimer.cancel();
    //     }
    //   });
    // }
  }

  // Handle timer ticks
  void _handleTick() {
    if (widget.scTimer.running) {
      setState(() {
        // Assuming scTimer has a mode property
        if (widget.scTimer.mode == TimerMode.countdown) {
          if (widget.scTimer.currentDuration == Duration.zero) {
            _timer.cancel();
            widget.scTimer.running = false;

            _countdownDoneFlash();
          }
        }
      });
    }
  }

  // void _loadCurrentDuration() {
  //    if (widget.scTimer.mode == TimerMode.stopwatch) {
  //     _startTime = widget.scTimer.createdAt.subtract(widget.scTimer.startingAt);
  //   } else {
  //     _startTime = widget.scTimer.createdAt;
  //   }

  //   //load in the current duration regardless of if the timer is running or not ensuring that the timer is accurate using widget.scTimer.createdAt as epoch time
  //   if (widget.scTimer.mode == TimerMode.stopwatch) {
  //     //! this is broken  we need to somehow keep track of when the timer was started (while also supporting pausing and resuming)
  //     currentDuration = DateTime.now().difference(_startTime!);
  //   } else {
  //     currentDuration = widget.scTimer.startingAt - DateTime.now().difference(_startTime!);
  //     if (currentDuration.isNegative) {
  //       currentDuration = Duration.zero;
  //       _timer.cancel();
  //       widget.scTimer.running = false;
  //       _countdownDoneFlash();
  //     }
  //   }

  //   // _handleTick();
  // }

  // Start the timer
  void _startTimer() {
    // _loadCurrentDuration();
    // _startTime = DateTime.now();//.add(widget.scTimer.startingAt);
    print(DateTime.now());
    // print(_startTime);
    _timer.cancel();
    _flashTimer.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 8), (_) => _handleTick());
  }

  // Flash the countdown clock when it reaches 0
  void _countdownDoneFlash() {
    _flashTimer.cancel();
    _flashTimer =
        Timer.periodic(Duration(milliseconds: widget.scTimer.flashRate ?? defaultFlashRate), (_) => _handleDoneFlash());
  }

  // Handle the flashing
  void _handleDoneFlash() {
    setState(() {
      countdownColor = countdownColor == widget.scTimer.color ? Colors.transparent : widget.scTimer.color;
    });
  }

  // Dispose resources
  @override
  void dispose() {
    _timer.cancel();
    _flashTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        // Column(children: [
        //   //title / id

        //   FittedBox(
        //     fit: BoxFit.scaleDown,
        //     child: Text(widget.scTimer.id)),

        //timer
        Stack(
      children: [
        // Countdown bar
        if (widget.scTimer.mode == TimerMode.countdown)
          Positioned.fill(
            left: 0,
            child: FractionallySizedBox(
              widthFactor:widget.scTimer.initialStartingAt.inMilliseconds == 0 ? 0 :
                  max(0,1 - (widget.scTimer.currentDuration.inMilliseconds / widget.scTimer.initialStartingAt.inMilliseconds)),
              child: Container(color: countdownColor.withOpacity(0.4)),
            ),
          ),
        Positioned(
          child: ClockDisplay(
            duration: widget.scTimer.currentDuration,
            mode: ClockDisplayMode.h24,
            msPrecision: widget.scTimer.msPrecision ?? defaultMsPrecision,
          ),
        ),
      ],
    );
    // ],);
  }
}
