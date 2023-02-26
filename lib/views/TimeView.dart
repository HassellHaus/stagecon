import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stagecon/controllers/OscController.dart';
import 'package:stagecon/views/OptionsView.dart';
import 'package:stagecon/widgets/TimerDisplay.dart';

class TimeView extends StatefulWidget {
  const TimeView({super.key, this.minSize = 400});

  final int minSize;

  @override
  State<TimeView> createState() => _TimeViewState();
}

class _TimeViewState extends State<TimeView> {
  OSCcontroler oscCon = Get.find();
  Map<String, TimerDisplay> timers = {
    // "test": TimerDisplay(startingAt: Duration(days: 3), running: true,),
    // "countdown": TimerDisplay(startingAt: Duration(seconds: 3), running: true, mode: TimerDisplayMode.countdown,),
    //  "test2": TimerDisplay(startingAt: Duration.zero, running: true,),
    //  "test3": TimerDisplay(startingAt: Duration.zero, running: true,),
    //  "test4": TimerDisplay(startingAt: Duration.zero, running: true,),
    //  "test5": TimerDisplay(startingAt: Duration.zero, running: true,),
    //  "test6": TimerDisplay(startingAt: Duration.zero, running: true,),
    //  "test7 and 8 and": TimerDisplay(startingAt: Duration.zero, running: true,),
  };
  Map<String, TimerDisplayController> timerControllers = {};


  @override
  void initState() {
    oscCon.addTimerEventListener(handleOSCEvents);
    super.initState();
  }

  handleOSCEvents(TimerEventOptions opt) {
    print(opt.operation);
    setState(() {
      switch(opt.operation) {
        
        case TimerEventOperation.set:
        if(timers[opt.id] == null) {
            timerControllers[opt.id] = TimerDisplayController(startingAt: opt.startingAt ?? Duration.zero, mode: opt.mode!);
            timers[opt.id] = TimerDisplay(
              controller: timerControllers[opt.id]!,
            );     
          } else {
            if(opt.startingAt!=null) timerControllers[opt.id]!.startingAt =opt.startingAt!;
            if(opt.mode!=null) timerControllers[opt.id]!.mode =opt.mode!;
          }
               
          break;
        case TimerEventOperation.reset:
          // if(timers[opt.id] != null) {
          //   timers[opt.id] = TimerDisplay(
          //     key: timers[opt.id]?.key,
          //     startingAt: timers[opt.id]?.startingAt ?? Duration.zero, 
          //   );
          // }
          timerControllers[opt.id]?.reset();
          break;
        case TimerEventOperation.start:
          timerControllers[opt.id]?.running = true;
          // if(timers[opt.id] != null) {
          //   timers[opt.id] = TimerDisplay(
          //     key: timers[opt.id]!.key,
          //     startingAt: timers[opt.id]!.startingAt, 
          //     running: true,
          //   );
          // }
          break;
        case TimerEventOperation.stop:
          timerControllers[opt.id]?.running = false;
          // if(timers[opt.id] != null) {
          //   timers[opt.id] = TimerDisplay(
          //     key: timers[opt.id]!.key,
          //     startingAt: timers[opt.id]!.startingAt, 
          //     running: false,
          //   );
          // }
          break;
        case TimerEventOperation.delete:
          timers.remove(opt.id);
          break;
        case TimerEventOperation.format:
          // TODO: Handle this case.
          break;
      }
      
    });
  }

  bool showTutorial = true;

  @override
  Widget build(BuildContext context) {
    int maxCrossCount = 2;
        //max((MediaQuery.of(context).size.width / widget.minSize).floor(),1);
        // print(maxCrossCount);
    int crossCount = 1;
    if (timers.length > 1) {
      crossCount =
          timers.length >= maxCrossCount ? maxCrossCount : timers.length;
    }
    // crossCount = min(timers.length, maxCrossCount);

    if(timers.length >0 ) {
      showTutorial = false;
    }

    // timers["test"] = TimerDisplay(key: timers["test"]!.key, startingAt: Duration.zero,running: true);

    return GestureDetector(
      onDoubleTap: () => Get.to(()=> const OptionsView(), fullscreenDialog:true),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white, fontSize: 3000),
        child: showTutorial
        ?   const Center(child: Text("Listening on port 4455. Double tap for options", style: TextStyle(color: Colors.grey, fontSize: 15),),)
        :GridView.count(
            shrinkWrap: true,
            crossAxisCount: crossCount,
            childAspectRatio: 2,
            children: timers.entries
                .map((e) => AnimatedContainer(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        border: Border.all(width: 3, color: e.value.countdownColor)),
                    duration: const Duration(milliseconds: 500),
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(e.key),
                              Flexible(
                                  child: DefaultTextStyle(
                                      style: const TextStyle(
                                          fontFamily: "RobotoMono",
                                          color: Colors.white,
                                          fontSize: 3000),
                                      child: e.value))
                            ]))))
                .toList()))
                
                
    );
  }
}
