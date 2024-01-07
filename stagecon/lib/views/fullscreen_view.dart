import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:stagecon/widgets/cue_lights/cue_light_edge_glow.dart';
import 'package:stagecon/widgets/cue_lights/cue_light_fullscreen_grid.dart';
import 'package:stagecon/widgets/cue_lights/cue_light_grid.dart';
import 'package:stagecon/widgets/timers/timer_grid.dart';

class FullScreenView extends StatelessWidget {
  const FullScreenView({super.key, this.tapToClose = false});

  final bool tapToClose;

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(data: CupertinoThemeData(brightness: Brightness.dark), child: 
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if(tapToClose) {
          Hive.box("preferences").put("full_screen_mode", false);
        }
      },
      child: Container(
        color: CupertinoColors.black,
        child: LayoutBuilder(builder: (_, constraints) { 
          
        //   return Column(
        //   children: [
        //     Expanded(child: TimerGrid()),
            
        //      SizedBox(
        //         height: max(100,constraints.maxHeight*0.1,),
        //         child: CueLightGrid(hideInactive: true),
        //       ),
        //       // SizedBox(
        //       //   height: max(100,constraints.maxHeight*0.1,),
        //       //   child: RotatingBorderWidget(colors: [CupertinoColors.systemRed, CupertinoColors.systemBlue, CupertinoColors.systemGreen, CupertinoColors.systemYellow, CupertinoColors.systemCyan, CupertinoColors.systemBrown])
        //       // ),
            
        //   ],
        // );

        return const Stack(children: [
          Positioned.fill(child: TimerGrid()),
          Positioned.fill(child: CuelightFullscreenGrid(),)
        ],);
        })
        
        // const TimerGrid(),
        
      ),
    ));
  }
}