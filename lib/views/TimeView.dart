import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stagecon/widgets/TimerDisplay.dart';


class TimeView extends StatefulWidget {
  const TimeView({super.key, this.minSize = 400});

  final int minSize;

  @override
  State<TimeView> createState() => _TimeViewState();
}

class _TimeViewState extends State<TimeView> {

  Map<String, TimerDisplay> timers = {
    "test": TimerDisplay(startingAt: Duration.zero, running: false,),
     "test2": TimerDisplay(startingAt: Duration.zero, running: true,),
     "test3": TimerDisplay(startingAt: Duration.zero, running: true,),
     "test4": TimerDisplay(startingAt: Duration.zero, running: true,),
     "test5": TimerDisplay(startingAt: Duration.zero, running: true,),
     "test6": TimerDisplay(startingAt: Duration.zero, running: true,),
     "test7 and 8 and": TimerDisplay(startingAt: Duration.zero, running: true,),
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  handleOSCEvents() {
    
  }

  @override
  Widget build(BuildContext context) {
    int maxCrossCount = (MediaQuery.of(context).size.width/widget.minSize).floor();
    int crossCount = 1;
    if(timers.length > 1) {
      crossCount = timers.length >=maxCrossCount?maxCrossCount:timers.length;
    }

    timers["test"] = TimerDisplay(key: timers["test"]!.key, startingAt: Duration.zero,running: true);


    return DefaultTextStyle(style: TextStyle(color: Colors.white, fontSize: 3000), child:    
       GridView.count(shrinkWrap: true, crossAxisCount: crossCount,childAspectRatio: 2, children: timers.entries.map((e) => AnimatedContainer(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(border: Border.all(
            width: 3,
            color: Colors.green
          )),
          duration: const Duration(milliseconds: 500),
          child:FittedBox( fit: BoxFit.scaleDown, child: 
         Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(e.key),
              Flexible(child: DefaultTextStyle(style: TextStyle(fontFamily: "RobotoMono", color: Colors.white, fontSize: 3000), child: e.value))
          ])
        )
      
      )).toList()
      )
    );
  }
}

