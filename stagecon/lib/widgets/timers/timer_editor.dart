import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stagecon/types/sc_timer.dart';
import 'package:stagecon/widgets/timers/duration_editor_controller.dart';

class TimerEditor extends StatefulWidget {
  const TimerEditor({super.key, required this.timer, this.editId = true});

  final ScTimer timer;
  final bool editId;


  static openModel(BuildContext context, {
      required ScTimer timer, 
      bool editId = true, 
      bool saveOnClose = false, 
      bool showSaveButton = false,
      bool showTitle = true
    }) async {
    bool saving = false;
    await showMacosSheet(
      barrierDismissible: true,
      context: context, builder: (context) {
      return MacosSheet(child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 24),

          if(showTitle) const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.clock_fill, size: 50,),
                Text("Edit Timer", style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ],
            ),

          const SizedBox(height: 8),


          TimerEditor(timer: timer, editId: editId,),

          if(showSaveButton) StatefulBuilder(
            builder: (BuildContext context, setState) {
              return PushButton(
                controlSize: ControlSize.large,
                child: const Text("Save"),
                onPressed: () async { 
                  setState(() => saving = true);
                  await timer.upsert();
                  if(context.mounted) Navigator.of(context).pop();
                },
              );
            },
          ),
          
        ]),
      ));
      
      
    });
    if(saveOnClose && !saving) {
      await timer.upsert();

    }
    
  }
  


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

            //Kind Stopwatch/Countdown
              MacosSegmentedControl(
                tabs: const [
                  MacosTab(label: "Countdown"),
                  MacosTab(label: "Stopwatch"),
                ],
                controller: tabController,
              ),
              const SizedBox(height: 4),
          //title
          CupertinoFormSection.insetGrouped(
            backgroundColor: const Color(0x00000000),
            children: [
              if(widget.editId)
              CupertinoTextFormFieldRow(
                placeholder: "Timer ID (Name)",
                onChanged: (value) {
                  setState(() {
                    widget.timer.id = value;
                  });
                },
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
