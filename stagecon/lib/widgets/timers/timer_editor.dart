import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stagecon/types/sc_timer.dart';

class TimerEditor extends StatefulWidget {
  const TimerEditor({super.key, required this.timer});

  final ScTimer timer;

  

  @override
  State<TimerEditor> createState() => _TimerEditorState();
}

class _TimerEditorState extends State<TimerEditor> {
  MacosTabController tabController = MacosTabController(length: 2);

  @override
  void initState() {
    tabController.addListener(changeMode);
    super.initState();
  }

  @override
  void dispose() {
    tabController.removeListener(changeMode);
    super.dispose();
  }

  changeMode() {
    setState(() {
      widget.timer.mode = tabController.index == 0 ? TimerMode.countdown : TimerMode.stopwatch;
    });
  }

  @override
  Widget build(BuildContext context) {
    //pupup background
    return Container(
        decoration: BoxDecoration(
          color: MacosColors.systemGrayColor.resolveFrom(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: CupertinoColors.systemGrey3.resolveFrom(context),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          //title
          CupertinoFormSection.insetGrouped(
            backgroundColor: const Color(0x00000000),
            children: [
              CupertinoTextFormFieldRow(
                onChanged: (value) {
                  setState(() {
                    widget.timer.id = value;
                  });
                },
              ),

              //Kind Stopwatch/Countdown
              MacosSegmentedControl(
                tabs: const [
                  MacosTab(label: "Countdown"),
                  MacosTab(label: "Stopwatch"),
                ],
                controller: tabController,
              ),

              //TODO: actual timer editor goes here
              
                CupertinoTextFormFieldRow(
                  placeholder: "Starting at (MS)",
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    setState(() {
                      widget.timer.startingAt = Duration(milliseconds: int.tryParse(value) ?? 0);
                    });
                  },
                ),
              
            ],
          )
        ]));
  }
}
