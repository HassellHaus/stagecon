import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class OSCExamples extends StatelessWidget {
  const OSCExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSliver(children: [
      SliverToBoxAdapter(
          child: CupertinoFormSection.insetGrouped(
            backgroundColor: Colors.transparent,
            children: const [
            _ExpandableExample(title: "Timers", child: Column(children: [
                CupertinoListTile.notched(title:  Text("Create/Edit a timer"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/[countdown|stopwatch]/set “Timer Name” ms s m h d ", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Reset a timer"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/timer/reset “Timer Name”", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Start/resume a timer"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/timer/start “Timer Name”", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Stop/pause a timer"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/timer/stop “Timer Name”", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Delete a timer"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/timer/delete “Timer Name”", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Delete all timers"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/timer/deleteAll", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Delete all countdowns or stopwatches"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/[countdown|stopwatch]/deleteAll", style: TextStyle(fontSize: 20),),)),
 
                CupertinoListTile.notched(title:  Text("Change a timer's color"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/timer/format/color \n “Timer Name” r[0-255] g[0-255] b[0-255] a[0-255]", maxLines: 2, style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Change the millisecond decimal precision"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/timer/format/msPrecision [0-3]", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Change countdown flash rate"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/timer/format/flashRate milliseconds(int)", style: TextStyle(fontSize: 20),),)),
            ]),),
            _ExpandableExample(title: "Cue Lights", child: SizedBox(height: 100, child: Placeholder()),),
            _ExpandableExample(title: "Messages", child: SizedBox(height: 100, child: Placeholder()),),
        // CupertinoListTile.notched(title: const Text("Timers"), )
      ]))
    ]);
  }
}

class _ExpandableExample extends StatefulWidget {
  const _ExpandableExample({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  State<_ExpandableExample> createState() => __ExpandableExampleState();
}

class __ExpandableExampleState extends State<_ExpandableExample> {
  late var expandableController = ExpandableController(initialExpanded: false);

  @override
  void dispose() {
    expandableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      
        color: Colors.transparent,
        child: ExpandablePanel(
            header: CupertinoListTile.notched(title: Text(widget.title), onTap: () => expandableController.toggle()),
            collapsed: Container(),
            expanded: widget.child,
            controller: expandableController,
            
            theme: const ExpandableThemeData(
              tapHeaderToExpand: true,
              useInkWell: false,
              hasIcon: true,
              
              // controller: ExpandableController(),
            )));
  }
}
