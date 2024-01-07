import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stagecon/views/desktop_view.dart';
import 'package:stagecon/views/fullscreen_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  


  late MediaQueryData mediaQueryData;

  @override
  void didChangeDependencies() {
    mediaQueryData = MediaQuery.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: Hive.box("preferences").listenable(keys: ["full_screen_mode"]),
    builder: (context, box, child) {
      if(box.get("full_screen_mode")) {
        return const FullScreenView(tapToClose: true,);
      } else {
        if(Platform.isIOS || Platform.isAndroid) {
          return CupertinoPageScaffold(
            backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
            child: const DesktopView());
        } else {

          return const DesktopView();
        }

      }
      
    }
    );

  }
}