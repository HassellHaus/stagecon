import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:stagecon/controllers/OscController.dart';
import 'package:stagecon/osc/osc.dart';

class OSCLogView extends StatefulWidget {
  const OSCLogView({super.key});

  @override
  State<OSCLogView> createState() => _OSCLogViewState();
}

class _OSCLogViewState extends State<OSCLogView> {
  OSCcontroler osc = Get.find();

  List<_MessageObj> messages = [
    // _MessageObj(message: OSCMessage("/test", arguments: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])),
  ];

  @override
  void initState() {
    osc.addLogEventListener(handleLogs);
    super.initState();
  }

  @override
  void dispose() {
    osc.removeLogEventListener(handleLogs);
    super.dispose();
  }

  handleLogs(OSCMessage message) {
    messages.add(_MessageObj(message: message));
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // backgroundColor: Color(0x00000000),
      // backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: const CupertinoNavigationBar(previousPageTitle: "Back", middle: Text("OSC Log")),
      child: DefaultTextStyle(style: CupertinoTheme.of(context).textTheme.textStyle,
        child: ListView.separated(
          separatorBuilder: (context, index) => Container(height: 1, color: CupertinoColors.systemGrey.resolveFrom(context)),
          reverse: true, itemBuilder: (context, index) {
        return _LogItem(message: messages[(messages.length-1) - index],);
      }, itemCount: messages.length,)
      )
      
      
    );
  }
}


class _LogItem extends StatelessWidget {
  const _LogItem({required this.message});
  final _MessageObj message;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      //time
      Text(DateFormat("yy-MM-dd hh:mm:ss").format(DateTime.now()), style: const TextStyle(fontSize: 8, fontFamily: "RobotoMono",),),
      const Text("|"),
      //message
      Flexible(child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.message.address, style: const TextStyle(fontSize: 15, fontFamily: "RobotoMono")),
          Flexible(child: Wrap(
            // mainAxisSize: MainAxisSize.min,

            children: message.message.arguments.map((e) => Text("$e(${e.runtimeType}) | ", style: const TextStyle(fontSize: 10, fontFamily: "RobotoMono"),)).toList(), 
          ))
          // Flexible(child: FittedBox(
          //   fit: BoxFit.scaleDown,
          //   child: 
          // ))
        ],
      ))
      
    ],);
  }
}

class _MessageObj {
  late DateTime received;
  OSCMessage message;
  _MessageObj({required this.message}) {
    received = DateTime.now();
  }
}