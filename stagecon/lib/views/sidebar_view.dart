import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stagecon/views/OSCLogView.dart';

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
    return DefaultTextStyle(style: MacosTheme.of(context).typography.body, 

    child: MacosTabView(
      controller: _tabController,
      tabs: const [
        MacosTab(label: "Message Log"),
        MacosTab(label: "OSC Log")
      ],
      children: const [
        Center(child: Text("Message Log")),
        OSCLogView()
      ],
    ));
  }
}