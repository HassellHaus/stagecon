import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:stagecon/views/OSCLogView.dart';
import 'package:stagecon/widgets/cue_lights/cue_light_grid.dart';
import 'package:stagecon/widgets/messages/message_list.dart';
import 'package:stagecon/widgets/messages/message_textbox.dart';

class SidebarView extends StatefulWidget {
  const SidebarView({super.key});

  @override
  State<SidebarView> createState() => _SidebarViewState();
}

class _SidebarViewState extends State<SidebarView> {
  MacosTabController _tabController = MacosTabController(initialIndex: 0, length: 2);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: MacosTheme.of(context).typography.body,
        child: MacosTabView(
          controller: _tabController,
          tabs: const [
            MacosTab(label: "Message Log"),
            MacosTab(label: "OSC Log"),
            // MacosTab(label: "Cue Lights")
          ],
          children: const [
            Column(children: [
              Expanded(
                child: CustomScrollView(
                  reverse: true,
                  slivers: [
                    MessageList(),
                  ],
                ),
              ),
              MessageTextbox()
            ]),

            // Center(child: Text("Message Log")),
            OSCLogView(),
            // CueLightGrid()
          ],
        ));
  }
}
