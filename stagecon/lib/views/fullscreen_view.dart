import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:stagecon/widgets/timers/timer_grid.dart';

class FullScreenView extends StatelessWidget {
  const FullScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(data: CupertinoThemeData(brightness: Brightness.dark), child: 
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Hive.box("preferences").put("full_screen_mode", false);
      },
      child: Container(
        color: CupertinoColors.black,
        child: const TimerGrid(),
      ),
    ));
  }
}