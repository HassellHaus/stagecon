import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:stagecon/controllers/OscController.dart';
import 'package:stagecon/osc/osc.dart';

class OSCLogView extends StatefulWidget {
  const OSCLogView({super.key});

  @override
  State<OSCLogView> createState() => _OSCLogViewState();
}

class _OSCLogViewState extends State<OSCLogView> {
  OSCcontroler osc = Get.find();

  List<_MessageObj> messages = [];

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
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(previousPageTitle: "Back", middle: Text("OSC Log")),
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
  const _LogItem({super.key, required this.message});
  final _MessageObj message;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      //time
      Text(message.received.toString(), style: TextStyle(fontSize: 8, fontFamily: "RobotoMono",),),
      const Text("|"),
      //message
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.message.address, style: TextStyle(fontSize: 15, fontFamily: "RobotoMono")),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
            mainAxisSize: MainAxisSize.min,
            children: message.message.arguments.map((e) => Text(e.toString() + "(${e.runtimeType}) | ", style: TextStyle(fontSize: 10, fontFamily: "RobotoMono"),)).toList(), )
          )
        ],
      )
      
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