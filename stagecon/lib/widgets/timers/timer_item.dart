import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stagecon/controllers/app_state.dart';
import 'package:stagecon/types/sc_timer.dart';
import 'package:stagecon/widgets/timers/timer_controls.dart';
import 'package:stagecon/widgets/timers/timer_display.dart';
import 'package:stagecon/widgets/timers/timer_editor.dart';

class TimerItem extends StatelessWidget {
  const TimerItem({super.key, required this.timer});

  final ScTimer timer;

  @override
  Widget build(BuildContext context) {
    AppState appState = Get.find();
    return AnimatedContainer(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(border: Border.all(width: 3, color: timer.color)),
        duration: const Duration(milliseconds: 100),
        child:  DefaultTextStyle(
                style: TextStyle(
                  fontFamily: "RobotoMono",
                  color:
                      const CupertinoDynamicColor.withBrightness(color: Color(0xff000000), darkColor: Color(0xffffffff))
                          .resolveFrom(context),
                  fontSize: 3000,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(child: AutoSizeText(
                        timer.id,
                        // style: const TextStyle(fontSize: 30000),
                      )),
                      Flexible(
                          child: FittedBox(child: TimerDisplay(
                        scTimer: timer,
                      ))),
                      // Obx(() => !appState.editMode.value? const SizedBox.shrink() :const Spacer()),
                      Obx(() => !appState.editMode.value? const SizedBox.shrink() :
                        TimerControls(timer: timer)
                      )
                    ])));
  }
}

