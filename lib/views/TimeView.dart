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
    print(opt.id);
    // return;
    
      switch(opt.operation) {
        
        case TimerEventOperation.set:
        if(timers[opt.id] == null) {
            timerControllers[opt.id] = TimerDisplayController(startingAt: opt.startingAt ?? Duration.zero, mode: opt.mode!);
            timers[opt.id] = TimerDisplay(
              key: ValueKey("TimeView-TimerDisplay-${opt.id}"),
              controller: timerControllers[opt.id]!,
            );    
            if(mounted) setState(() {}); 
          } else {
            if(opt.startingAt!=null) timerControllers[opt.id]!.startingAt =opt.startingAt!;
            if(opt.mode!=null) timerControllers[opt.id]!.mode =opt.mode!;
          }
               
          break;
        case TimerEventOperation.reset:

          timerControllers[opt.id]?.reset();
          break;
        case TimerEventOperation.start:
          timerControllers[opt.id]?.running = true;

          break;
        case TimerEventOperation.stop:
          timerControllers[opt.id]?.running = false;

          break;
        case TimerEventOperation.delete:
          timers.remove(opt.id);
          timerControllers.remove(opt.id);
          if(mounted) setState(() {});
          break;
        case TimerEventOperation.format:
          // TODO: Handle this case.
          break;
      }
    
    
    // print("post");
  }

  bool showTutorial = true;


  ///Clamps the cross count to a square power
  calculateCrossCount(int n) {
    return sqrt(n).ceil();
  }

  @override
  Widget build(BuildContext context) {
    //todo: optimize the building of the clock items.  Maybe separate them from the main build method?
    //calculate the optimal cross count
    int crossCount = calculateCrossCount(timers.length);
    double aspect =  MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;;

    // bool isPortrait = MediaQuery.of(context).size.width < MediaQuery.of(context).size.height;
    // print(isPortrait);
    //   if(isPortrait) {
    //     aspect =  MediaQuery.of(context).size. width/ MediaQuery.of(context).size. height;
    //   } else {
        
    // }

    if(timers.isNotEmpty ) {
      showTutorial = false;
    }


    return GestureDetector(
      onDoubleTap: () => Get.to(()=> const ConfigurationView(), fullscreenDialog:true),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white, fontSize: 3000),
        child: showTutorial
        ?   const Center(child: Text("Listening on port 4455. Double tap for configuration", style: TextStyle(color: Colors.grey, fontSize: 15),),)
        :GridView.count(
            shrinkWrap: true,
            crossAxisCount: crossCount,
            childAspectRatio: aspect,
            children: timers.entries
                .map((e) => AnimatedContainer(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        border: Border.all(width: 3, color: e.value.controller.countdownColor)),
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
