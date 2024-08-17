import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stagecon/widgets/cue_lights/cue_light_fullscreen_grid.dart';
import 'package:stagecon/widgets/cue_lights/cue_light_grid.dart';
import 'package:stagecon/widgets/messages/message_fullscreen_container.dart';
import 'package:stagecon/widgets/timers/timer_grid.dart';

class FullScreenView extends StatelessWidget {
  const FullScreenView({super.key, this.tapToClose = false});

  final bool tapToClose;


  static openWithModel(BuildContext context) {
    showMacosAlertDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) => MacosAlertDialog(
                              appIcon: MacosIcon(CupertinoIcons.fullscreen, size: 50, color: CupertinoColors.systemRed.resolveFrom(context)),
                              title: Text(
                                'Enter Fullscreen Mode?',
                                style: MacosTheme.of(context).typography.headline,
                              ),
                              message: Text(
                                'Tap anywhere to exit fullscreen mode.  This will be remembered for future launches.',
                                textAlign: TextAlign.center,
                                style: MacosTypography.of(context).headline,
                              ),
                              primaryButton: PushButton(
                                controlSize: ControlSize.large,
                                child: const Text('Enter Fullscreen'),
                                onPressed: () {
                                  Hive.box("preferences").put("full_screen_mode", true);
                                  Navigator.of(context).pop();
                                },
                              ),
                              secondaryButton: PushButton(
                                controlSize: ControlSize.large,
                                secondary: true,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                            ));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(data: ThemeData.dark(), child: CupertinoTheme(data: CupertinoThemeData(brightness: Brightness.dark), child: 
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if(tapToClose) {
          Hive.box("preferences").put("full_screen_mode", false);
        }
      },
      child: Container(
        color: CupertinoColors.black,
        child: MessageFullScreenContainer( // shows messages to the side of hte content
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
    ))));
  }
}