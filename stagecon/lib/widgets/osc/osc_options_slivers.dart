import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:stagecon/controllers/OscController.dart';
import 'package:stagecon/widgets/timers/duration_editor_controller.dart';

class OSCOptionsSlivers extends StatefulWidget {
  const OSCOptionsSlivers({super.key});

  @override
  State<OSCOptionsSlivers> createState() => _OSCOptionsSliversState();
}

class _OSCOptionsSliversState extends State<OSCOptionsSlivers> {
  late DurationEditorController _durationEditorController;
  FocusNode _durationEditorFocusNode = FocusNode();
  // TextEditingController _durationEditorController = TextEditingController();

  @override
  void initState() {
    _durationEditorController = DurationEditorController(focusNode: _durationEditorFocusNode);
    super.initState();
  }

  @override
  void dispose() {
    _durationEditorController.dispose();
    super.dispose();
  }
  OSCcontroler osc = Get.find();
  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        //server state
        SliverToBoxAdapter(
          child: CupertinoTextField(
            focusNode: _durationEditorFocusNode,
            controller: _durationEditorController,
          )
        
            // child: DurationEditor(duration: Duration(days: 3),)

        ),

      ]);
  }
}