import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stagecon/types/sc_timer.dart';
import 'package:stagecon/widgets/timers/timer_item.dart';

class TimerGrid extends StatelessWidget {
  const TimerGrid({super.key});

  ///Clamps the cross count to a square power
  calculateCrossCount(int n) {
    return sqrt(n).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: Hive.box<ScTimer>("timers").listenable(), builder: (context, timers, child) {
      int crossCount = timers.isNotEmpty?calculateCrossCount(timers.length):1;
      // double aspect =  MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;

      // if(timers.length == 2) {
      //   crossCount = 1;
      //   aspect = MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height*0.5);
      // }


      return LayoutBuilder(builder: (context, constraints) {
        
        double aspect =  constraints.maxWidth / constraints.maxHeight;
        print(constraints.minHeight);

        if(timers.length == 2) {
          crossCount = 1;
          aspect = constraints.maxWidth / (constraints.maxHeight*0.5);
        }
        return GridView.count(
            // shrinkWrap: true,
            crossAxisCount: crossCount,
            childAspectRatio: aspect,
            children: timers.values
                .map((e) => TimerItem(
                      timer: e,
                ))
                .toList()
                ..sort((a, b) {
                  //if the timer is a stopwatch it should be sorted first with the newest first
                  //if the timer is a countdown it should be sorted after stopwatches but sorted with the shortest remaining time first
                  if (a.timer.mode == TimerMode.stopwatch && a.timer.mode != TimerMode.stopwatch) {
                    return -1;
                  } else if (a.timer.mode != TimerMode.stopwatch && b.timer.mode == TimerMode.stopwatch) {
                    return 1;
                  } else if (a.timer.mode == TimerMode.stopwatch && b.timer.mode == TimerMode.stopwatch) {
                    return b.timer.currentDuration.compareTo(a.timer.currentDuration);
                  } else {
                    return a.timer.currentDuration.compareTo(b.timer.currentDuration);
                  }

                })
                );
      });

    });
  }
}