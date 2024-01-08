import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:stagecon/controllers/OscController.dart';
import 'package:stagecon/widgets/network_info_list_section.dart';
import 'package:stagecon/widgets/osc/osc_examples.dart';
import 'package:stagecon/widgets/timers/duration_editor_controller.dart';

class OSCOptionsSlivers extends StatefulWidget {
  const OSCOptionsSlivers({super.key});

  @override
  State<OSCOptionsSlivers> createState() => _OSCOptionsSliversState();
}

class _OSCOptionsSliversState extends State<OSCOptionsSlivers> {
  // late DurationEditorController _durationEditorController;
  // FocusNode _durationEditorFocusNode = FocusNode();
  // TextEditingController _durationEditorController = TextEditingController();
  var preferences =  Hive.box('preferences');

  OSCcontroler osc = Get.find();

  @override
  void initState() {
    // _durationEditorController = DurationEditorController(focusNode: _durationEditorFocusNode);
    super.initState();
  }

  @override
  void dispose() {
    // _durationEditorController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [

        const SliverPadding(padding: EdgeInsets.only(top: 20)),

        SliverToBoxAdapter(
          child: CupertinoFormSection.insetGrouped(
            backgroundColor: const Color(0x00000000),
            children: [

              ValueListenableBuilder(valueListenable: preferences.listenable(keys: ["osc_server_port"]), builder: (context, value, child) {
                return CupertinoTextFormFieldRow(
                  prefix: const Text("OSC Server Port"),
                  placeholder: "4455",
                  initialValue: preferences.get("osc_server_port").toString(),
                  maxLength: 5,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onFieldSubmitted: (value) async  {
                    var port = int.tryParse(value) ?? 4455;
                    if (port < 0 || port > 65535) {
                      port = preferences.get("osc_server_port");
                      osc.port = port;
                      osc.listen();
                      setState(() {
                        
                      });
                      return;
                    }
                    await preferences.put("osc_server_port", port);
                    osc.port = port;
                    osc.listen();
                  },
                );
              })
              
      ])),
        const NetworkInfoListSection(),
        const SliverToBoxAdapter(child: Text("Examples")),
        const OSCExamples(),
      ]);
  }
}