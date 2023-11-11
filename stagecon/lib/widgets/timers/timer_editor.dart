import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stagecon/types/sc_timer.dart';
import 'package:stagecon/widgets/timers/duration_editor_controller.dart';

class TimerEditor extends StatefulWidget {
  const TimerEditor({super.key, required this.timer, this.editId = true});

  final ScTimer timer;
  final bool editId;
  


  @override
  State<TimerEditor> createState() => _TimerEditorState();
}

class _TimerEditorState extends State<TimerEditor> {
  MacosTabController tabController = MacosTabController(length: 2);
  late DurationEditorController durationEditorController;
  FocusNode durationEditorFocusNode = FocusNode();

  @override
  void initState() {
    tabController.addListener(changeMode);
    durationEditorController = DurationEditorController(focusNode: durationEditorFocusNode, duration: widget.timer.initialStartingAt);
    tabController.index = widget.timer.mode == TimerMode.countdown ? 0 : 1;
    durationEditorController.addListener(() {
      setState(() {
        widget.timer.initialStartingAt = durationEditorController.duration;
        // widget.timer.startingAt = widget.timer.initialStartingAt;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    durationEditorController.dispose();
    durationEditorFocusNode.dispose();
    tabController.removeListener(changeMode);
    super.dispose();
  }

  changeMode() {
    setState(() {
      widget.timer.mode = tabController.index == 0 ? TimerMode.countdown : TimerMode.stopwatch;
      widget.timer.initialStartingAt = durationEditorController.duration;
    });
  }



  @override
  Widget build(BuildContext context) {
    //pupup background
    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          //title
          CupertinoFormSection.insetGrouped(
            backgroundColor: const Color(0x00000000),
            children: [
              if(widget.editId)
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
                  keyboardType: TextInputType.number,
                  focusNode: durationEditorFocusNode,
                  controller: durationEditorController,

                  // inputFormatters: [TextInputFormatter.withFunction((oldValue, newValue) => null)],
                  // onChanged: (value) {
                  //   setState(() {
                  //     widget.timer.startingAt = Duration(milliseconds: int.tryParse(value) ?? 0);
                  //   });
                  // },
                ),
              
            ],
          )
        ]);
  }
}
