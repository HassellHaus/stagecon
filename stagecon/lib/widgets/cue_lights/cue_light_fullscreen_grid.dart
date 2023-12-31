// import 'dart:math';

// import 'package:flutter/cupertino.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:stagecon/types/sc_cuelight.dart';

// class CuelightFullscreenGrid extends StatelessWidget {
//   const CuelightFullscreenGrid({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(valueListenable: Hive.box<ScCueLight>("cuelights").listenable(), builder: (context, cuelights, child) {
//       int crossCount = cuelights.isNotEmpty?sqrt(cuelights.length).ceil():1;
//       // double aspect =  MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;

//       // if(timers.length == 2) {
//       //   crossCount = 1;
//       //   aspect = MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height*0.5);
//       // }


//       return LayoutBuilder(builder: (context, constraints) {
        
//         double aspect =  constraints.maxWidth / constraints.maxHeight;
//         print(constraints.minHeight);

//         if(cuelights.length == 2) {
//           crossCount = 1;
//           aspect = constraints.maxWidth / (constraints.maxHeight*0.5);
//         }
//         return GridView.count(
//             // shrinkWrap: true,
//             crossAxisCount: crossCount,
//             childAspectRatio: aspect,
//             children: cuelights.values
//                 .map((e) => TimerItem(
//                       timer: e,
//                 ))
//                 .toList()
//                 ..sort((a, b) {
//                   //if the timer is a stopwatch it should be sorted first with the newest first
//                   //if the timer is a countdown it should be sorted after stopwatches but sorted with the shortest remaining time first
//                   if (a.timer.mode == TimerMode.stopwatch && a.timer.mode != TimerMode.stopwatch) {
//                     return -1;
//                   } else if (a.timer.mode != TimerMode.stopwatch && b.timer.mode == TimerMode.stopwatch) {
//                     return 1;
//                   } else if (a.timer.mode == TimerMode.stopwatch && b.timer.mode == TimerMode.stopwatch) {
//                     return b.timer.currentDuration.compareTo(a.timer.currentDuration);
//                   } else {
//                     return a.timer.currentDuration.compareTo(b.timer.currentDuration);
//                   }

//                 })
//                 );
//       });

//     });
// }