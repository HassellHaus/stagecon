import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:stagecon/controllers/OscController.dart';
import 'package:stagecon/widgets/timers/duration_editor.dart';

class OSCOptionsSlivers extends StatefulWidget {
  const OSCOptionsSlivers({super.key});

  @override
  State<OSCOptionsSlivers> createState() => _OSCOptionsSliversState();
}

class _OSCOptionsSliversState extends State<OSCOptionsSlivers> {
  OSCcontroler osc = Get.find();
  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        //server state
        SliverToBoxAdapter(
            // child: DurationEditor(duration: Duration(days: 3),)
        ),

      ]);
  }
}