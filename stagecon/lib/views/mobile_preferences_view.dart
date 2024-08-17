

import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stagecon/views/AboutView.dart';
import 'package:stagecon/views/ConfigurationView.dart';
import 'package:stagecon/widgets/osc/osc_options_slivers.dart';
import 'package:stagecon/widgets/server_proxy/proxy_activity_indicator.dart';
import 'package:stagecon/widgets/server_proxy/proxy_options_slivers.dart';

class PreferencesView extends StatefulWidget {
  const PreferencesView({super.key});

  @override
  State<PreferencesView> createState() => _PreferencesViewState();
}

class _PreferencesViewState extends State<PreferencesView> {



  @override
  Widget build(BuildContext context) {


    return CupertinoListSection.insetGrouped(
      children: [
        CupertinoListTile(
          title: const Text("Proxy"),
          trailing: const Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const _MobilePreferencesPageContainerView(title: "Proxy", child: CustomScrollView(slivers: [ProxyOptionsSlivers(),],))));
          },
        ),

        CupertinoListTile(
          title: const Text("OSC Settings"),
          trailing: const Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const _MobilePreferencesPageContainerView(title: "OSC Settings", child:  CustomScrollView(slivers: const [OSCOptionsSlivers(),],))));
          },
        ),
        CupertinoListTile(
          title: const Text("About"),
          trailing: const Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.of(context).push(CupertinoPageRoute(builder: (context) => _MobilePreferencesPageContainerView(title: "About", child: const AboutView())));
          },
        ),
      ],
    );
  }
}

 class _MobilePreferencesPageContainerView extends StatelessWidget {
  const _MobilePreferencesPageContainerView({super.key, required this.title, required this.child });

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
        trailing: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProxyActivityIndicator()
          ],
        ),
      ),
      child: Padding(padding: EdgeInsets.only(top: 40), child: child),
    );
  }
}