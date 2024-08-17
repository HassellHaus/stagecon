import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stagecon/controllers/app_state.dart';
import 'package:stagecon/types/sc_cuelight.dart';
import 'package:stagecon/types/sc_timer.dart';
import 'package:stagecon/views/AboutView.dart';
import 'package:stagecon/views/fullscreen_view.dart';
import 'package:stagecon/views/mobile_preferences_view.dart';
import 'package:stagecon/views/sidebar_view.dart';
import 'package:stagecon/widgets/cue_lights/cue_light_fullscreen_grid.dart';
import 'package:stagecon/widgets/cue_lights/cue_light_grid.dart';
import 'package:stagecon/widgets/server_proxy/proxy_activity_indicator.dart';
import 'package:stagecon/widgets/timers/timer_editor.dart';
import 'package:stagecon/widgets/timers/timer_grid.dart';

class MobileView extends StatefulWidget {
  const MobileView({super.key});

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  AppState appState = Get.find();
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: [
          BottomNavigationBarItem(icon: const Icon(CupertinoIcons.clock), label: "Timers"),
          BottomNavigationBarItem(icon: const Icon(CupertinoIcons.lightbulb), label: "Cuelights"),
          BottomNavigationBarItem(icon: const Icon(CupertinoIcons.bubble_left), label: "Messages"),
          BottomNavigationBarItem(icon: const Icon(CupertinoIcons.settings), label: "Settings"),
        ]),
        tabBuilder: (context, index) {
          return switch (index) {
            0 =>  _MobilePageContainerView(title:"Timers", child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
              // IgnorePointer(child: CuelightFullscreenGrid(),),

              Expanded(child: TimerGrid()),
              ValueListenableBuilder(valueListenable: Hive.box<ScCueLight>("cuelights").listenable(), builder: (context, cuelights, child) {
                var anyActiveCuelights = cuelights.values.fold(false, (previousValue, element) => previousValue || element.state != CueLightState.inactive);
                if(anyActiveCuelights) {
                  return Container( constraints: BoxConstraints(maxHeight: 150), child: CuelightFullscreenGrid());
                } else {
                  return const SizedBox.shrink();
                }
                
              },),
            ],)),
            1 => const _MobilePageContainerView(title:"Cuelights", child: CueLightGrid()),
            2 => const _MobilePageContainerView(title:"Messages", child: SidebarView()),
            3 => const _MobilePageContainerView(title:"Preferences", child: PreferencesView()),
            int() => const Text("Invalid Index"),
          };
        });
  }
}

class _MobilePageContainerView extends StatelessWidget {
  const _MobilePageContainerView({super.key, required this.title, required this.child});

  final Widget child;
  final String title;
  final bool isEventsPage = false;

  

  @override
  Widget build(BuildContext context) {
    AppState appState = Get.find();
    var safePadding = MediaQuery.of(context).padding;
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: Row(mainAxisSize: MainAxisSize.min, children: [ const ProxyActivityIndicator() ]),
          middle: Text(title),
          trailing:  Row(mainAxisSize: MainAxisSize.min, children: [
            
              CupertinoButton(padding: EdgeInsets.zero, child: const Icon(CupertinoIcons.add), onPressed:  () async {
                ScTimer timer = ScTimer();
                await TimerEditor.openModel(context, timer: timer, editId: true, saveOnClose: false, showSaveButton: true, showTitle: true);
              }),
              CupertinoButton(padding: EdgeInsets.zero, child: Obx(() => appState.editMode.value ? const Icon(CupertinoIcons.circle_grid_3x3_fill) : const Icon(CupertinoIcons.circle_grid_3x3)), onPressed: () {
                appState.editMode.value = !appState.editMode.value;
              }),
               CupertinoButton(padding: EdgeInsets.zero, child: const Icon(CupertinoIcons.fullscreen), onPressed: () {
                FullScreenView.openWithModel(context);
              }),

              // if (isEventsPage) const CupertinoButton(child: Icon(CupertinoIcons.add), onPressed: onPressed),
            
            ]),
        ),
        child: Padding(
          padding: EdgeInsets.only(top:safePadding.top + 45, bottom: safePadding.bottom + 0),
          child: child,
        ));
  }
}



// class _ extends StatelessWidget {
//   const _({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }