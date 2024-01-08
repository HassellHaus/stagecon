import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              _Example(title: "Create/Edit a timer", action: "/stagecon/[countdown|stopwatch]/set \"Timer Name\" ms s m h d"),
              _Example(title: "Reset a timer", action: "/stagecon/timer/reset \"Timer Name\""),
              _Example(title: "Start/resume a timer", action: "/stagecon/timer/start \"Timer Name\""),
              _Example(title: "Stop/pause a timer", action: "/stagecon/timer/stop \"Timer Name\""),
              _Example(title: "Delete a timer", action: "/stagecon/timer/delete \"Timer Name\""),
              _Example(title: "Delete all timers", action: "/stagecon/timer/deleteAll"),
              _Example(title: "Delete all countdowns or stopwatches", action: "/stagecon/[countdown|stopwatch]/deleteAll"),
              _Example(title: "Change a timer's color", action: "/stagecon/timer/format/color \"Timer Name\" r[0-255] g[0-255] b[0-255] a[0-255]"),
              _Example(title: "Change the millisecond decimal precision", action: "/stagecon/timer/format/msPrecision \"Timer Name\" [0-3]"),
              _Example(title: "Change countdown flash rate", action: "/stagecon/timer/format/flashRate \"Timer Name\" milliseconds(int)"),

                
            ]),),
            _ExpandableExample(title: "Cue Lights", child: Column(children: [
              _Example(title: "Set cuelight state", action: "/stagecon/cuelight/state \"Cuelight ID\" [inactive|standby|active]"),
              _Example(title: "The default cuelights have IDs that match their color in lowercase"),
              _Example(title: "More functions coming soon"),
            ],)),
            _ExpandableExample(title: "Messages", child: Column(children: [
              _Example(title: "Send a message", action: "/stagecon/message/post \"Message Title\" \"Message Content\" ttl(ms)"),
            ],)),
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


class _Example extends StatefulWidget {
  const _Example({super.key, required this.title, this.action});

  final String title;
  final String? action;

  @override
  State<_Example> createState() => _ExampleState();
}

class _ExampleState extends State<_Example> {
  bool showCopied = false;
  void copy() {
    Clipboard.setData(ClipboardData(text: widget.action!));
    setState(() {
      showCopied = true;
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        showCopied = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
      return   CupertinoListTile.notched(
        title: Text(widget.title), 
        subtitle: widget.action==null?null:FittedBox( 
            fit: BoxFit.scaleDown, 
            child: showCopied
                  ? const Text(
                      "Copied to clipboard",
                      style: TextStyle(fontSize: 20),
                    )
                  : Text(
                      widget.action!,
                      style: const TextStyle(fontSize: 20),
                      // key: UniqueKey(),
                    ),
        ),

        
        trailing: widget.action==null?null:Icon(CupertinoIcons.doc_on_clipboard_fill),
        onTap: widget.action==null?null:copy,    
      );
  }
}