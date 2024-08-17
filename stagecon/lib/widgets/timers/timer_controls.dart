
import 'package:flutter/cupertino.dart';
import 'package:stagecon/types/sc_timer.dart';
import 'package:stagecon/widgets/timers/timer_editor.dart';

class TimerControls extends StatelessWidget {
  const TimerControls({super.key, required this.timer});

  final ScTimer timer;

  @override
  Widget build(BuildContext context) {
    return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(child: FittedBox(child:_TimerItemButton(
                              hint: "Start Timer",
                              onPressed: () {
                                timer.running = !timer.running;
                                timer.upsert();
                              },
                              child: const Icon(CupertinoIcons.play_arrow_solid)))),
                          Flexible(child: FittedBox(child:_TimerItemButton(
                              hint: "Edit Timer",
                              onPressed: () async {

                                await TimerEditor.openModel(context, timer: timer, editId: false, saveOnClose: false, showSaveButton: true,);

                                
                                // timer.running = !timer.running;
                                // timer.upsert();
                              },
                              child: const Icon(CupertinoIcons.pen)))),
                          Flexible(child: FittedBox(child:_TimerItemButton(
                              hint: "Reset Timer",
                              onPressed: () {
                                timer.reset();
                                timer.upsert();
                              },
                              child: const Icon(CupertinoIcons.refresh_bold)))),
                          Flexible(child: FittedBox(child:_TimerItemButton(
                              hint: "Delete Timer",
                              onPressed: () {
                                ScTimer.delete(timer.dbId);
                              },
                              child: const Icon(CupertinoIcons.trash)))),

                        ],
                      );
  }
}



class _TimerItemButton extends StatelessWidget {
  const _TimerItemButton({super.key, required this.child, required this.onPressed, this.hint});

  final Widget child;
  final VoidCallback onPressed;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    var w = GestureDetector(
            onTap: onPressed,
            child: Container(
                padding: const EdgeInsets.all(5),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey5.resolveFrom(context), borderRadius: BorderRadius.circular(5)),
                child: child)
            
            );
    
    return Semantics(
        button: true,
        enabled: true,
        onTapHint: hint,
        child: w);
  }
}
