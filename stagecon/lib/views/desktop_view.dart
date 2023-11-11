import 'package:flutter/cupertino.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stagecon/controllers/app_state.dart';
import 'package:stagecon/types/sc_timer.dart';
import 'package:stagecon/views/ConfigurationView.dart';
import 'package:stagecon/views/OSCLogView.dart';
import 'package:stagecon/views/preferences_view.dart';
import 'package:stagecon/views/sidebar_view.dart';
import 'package:stagecon/widgets/overlay_container.dart';
import 'package:stagecon/widgets/server_proxy/proxy_activity_indicator.dart';
import 'package:stagecon/widgets/server_proxy/proxy_options_slivers.dart';
import 'package:stagecon/widgets/timers/timer_editor.dart';
import 'package:stagecon/widgets/osc/osc_options_slivers.dart';
import 'package:stagecon/widgets/timers/timer_grid.dart';

class DesktopView extends StatefulWidget {
  const DesktopView({super.key});

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  AppState appState = Get.find();
  int pageIndex = 0;

  late MediaQueryData mediaQueryData;
  @override
  void didChangeDependencies() {
    mediaQueryData = MediaQuery.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: mediaQueryData.padding.top),
      child: MacosWindow(
        // disableWallpaperTinting: true,

        // backgroundColor: CupertinoColors.systemRed.resolveFrom(context),
        sidebar: Sidebar(
          shownByDefault: mediaQueryData.size.width > 556.0,
          windowBreakpoint: 200,
          minWidth: 200,
          builder: (context, scrollController) {
            return SidebarItems(
              selectedColor: MacosTheme.of(context).primaryColor,
              currentIndex: pageIndex,
              scrollController: scrollController,
              itemSize: SidebarItemSize.large,
              onChanged: (i) {
                setState(() => pageIndex = i);
              },
              items: const [
                SidebarItem(
                  label: Text('Events'),
                ),
                SidebarItem(
                  label: Text('Proxy'),
                ),
                SidebarItem(
                  label: Text('OSC'),
                ),
                SidebarItem(
                  label: Text('Preferences'),
                ),
              ],
            );
          },
        ),
        endSidebar: Sidebar(
          startWidth: 200,
          minWidth: 200,
          maxWidth: 300,
          // windowBreakpoint: 0,
          shownByDefault: false,
          builder: (context, _) {
            // return const Center(
            //   child: Text('End Sidebar'),
            // );
            return const SidebarView();
          },
        ),

        // titleBar: TitleBar(
        //   title: const Text('Stagecon'),
        //   // actions: [
        //   //   CloseButton(),
        //   //   MinimizeButton(),
        //   //   MaximizeButton(),
        //   // ],
        // ),

        child: Builder(
            builder: (context) => MacosScaffold(
                  toolBar: ToolBar(
                    enableBlur: true,
                    leading: ToolBarIconButton(
                      icon: const MacosIcon(CupertinoIcons.sidebar_left),
                      label: "Show Menu",
                      showLabel: false,
                      onPressed: () {
                        setState(() {
                          MacosWindowScope.of(context).toggleSidebar();
                        });
                      },
                    ).build(context, ToolbarItemDisplayMode.inToolbar),
                    title: const Text("Stagecon"),
                    actions: [
                      CustomToolbarItem(
                          tooltipMessage: "Proxy Status",
                          inToolbarBuilder: (context) {
                            return const Padding(padding: const EdgeInsets.only(right: 8.0), child: ProxyActivityIndicator());

                            // const ProxyActivityIndicator();
                          }),
                      ToolBarIconButton(
                                      label: "Add New",
                                      showLabel: false,
                                      icon: const MacosIcon(CupertinoIcons.add),
                                      // const MacosIcon(CupertinoIcons.circle_grid_3x3),
                                      onPressed: () async {
                                        ScTimer timer = ScTimer();
                                        await TimerEditor.openModel(context, timer: timer, editId: true, saveOnClose: false, showSaveButton: true, showTitle: true);
                        }),

                      // CustomToolbarItem(
                      //     tooltipMessage: "Add New",
                      //     inToolbarBuilder: (context) {
                      //       return OverlayContainer(
                      //             buttonBuilder: (context, showMenu) {
                      //               return ToolBarIconButton(
                      //                 label: "Add New",
                      //                 showLabel: false,
                      //                 icon: const MacosIcon(CupertinoIcons.add),
                      //                 // const MacosIcon(CupertinoIcons.circle_grid_3x3),
                      //                 onPressed: () {
                      //                   showMenu();
                      //                 }).build(context, ToolbarItemDisplayMode.inToolbar);
                      //             }, 
                      //             overlayBuilder: (context, duration) {
                      //               ScTimer timer = ScTimer();
                      //               return SizedBox(
                      //                 width: 400,
                      //                 child: TimerEditor(timer: timer));
                      //             },
                      //             anchor: const Aligned(follower: Alignment.topRight, target: Alignment.bottomLeft),
                      //           );
                            

                      //       // const ProxyActivityIndicator();
                      //     }),
                      // ToolBarIconButton(
                      //   label: "Add New",
                      //   showLabel: false,
                      //   icon: Obx(() => appState.editMode.value ? const MacosIcon(CupertinoIcons.circle_grid_3x3_fill ): const MacosIcon(CupertinoIcons.circle_grid_3x3)),
                      //   // const MacosIcon(CupertinoIcons.circle_grid_3x3),
                      //   onPressed: () {
                      //     appState.editMode.value = !appState.editMode.value;

                      // }).,
                      ToolBarIconButton(
                          label: "Edit Mode",
                          showLabel: false,
                          icon: Obx(() => appState.editMode.value ? const MacosIcon(CupertinoIcons.circle_grid_3x3_fill) : const MacosIcon(CupertinoIcons.circle_grid_3x3)),
                          // const MacosIcon(CupertinoIcons.circle_grid_3x3),
                          onPressed: () {
                            appState.editMode.value = !appState.editMode.value;
                          }),

                      // const ToolBarDivider(),
                      // CustomToolbarItem(inToolbarBuilder: inToolbarBuilder)
                      ToolBarIconButton(
                        label: "Full Screen Mode",
                        showLabel: false,
                        icon: const MacosIcon(CupertinoIcons.fullscreen),
                        onPressed: () {
                          // setState(() {
                          //ask the user if they want to enter fuillscreen mode
                          showMacosAlertDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) => MacosAlertDialog(
                              appIcon: MacosIcon(CupertinoIcons.fullscreen, size: 50, color: CupertinoColors.systemRed.resolveFrom(context)),
                              title: Text(
                                'Enter Fullscreen Mode?',
                                style: MacosTheme.of(context).typography.headline,
                              ),
                              message: Text(
                                'Tap anywhere to exit fullscreen mode.  This will be remembered for future launches.',
                                textAlign: TextAlign.center,
                                style: MacosTypography.of(context).headline,
                              ),
                              primaryButton: PushButton(
                                controlSize: ControlSize.large,
                                child: const Text('Enter Fullscreen'),
                                onPressed: () {
                                  Hive.box("preferences").put("full_screen_mode", true);
                                  Navigator.of(context).pop();
                                },
                              ),
                              secondaryButton: PushButton(
                                controlSize: ControlSize.large,
                                secondary: true,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                            ));
                                // Hive.box("preferences").put("full_screen_mode", true);
                              // });
                            },
                          ),
                          if(mediaQueryData.size.width > 556.0)
                          ToolBarIconButton(
                            label: "Show Right Sidebar",
                            showLabel: false,
                            icon: const MacosIcon(CupertinoIcons.sidebar_right),
                            onPressed: () {
                              setState(() {
                                MacosWindowScope.of(context).toggleEndSidebar();
                              });
                            },
                          )
                        ],
                      ),
                      children: [
                        ContentArea(builder: (context, scroll) {
                          return IndexedStack(
                            index: pageIndex,
                            children: [
                              const TimerGrid(),
                              CustomScrollView(controller: scroll, slivers: const [ProxyOptionsSlivers(),],),
                              CustomScrollView(controller: scroll, slivers: const [OSCOptionsSlivers(),],),
                            //  Center(child: DurationEditor(duration: Duration(seconds: 10),)), 
                             const PreferencesView()
                             ],
                          );

                          // Hive.box("preferences").put("full_screen_mode", true);
                          // });
                        },
                      ),
                      // if (mediaQueryData.size.width > 556.0)
                      //   ToolBarIconButton(
                      //     label: "Show Right Sidebar",
                      //     showLabel: false,
                      //     icon: const MacosIcon(CupertinoIcons.sidebar_right),
                      //     onPressed: () {
                      //       setState(() {
                      //         MacosWindowScope.of(context).toggleEndSidebar();
                      //       });
                      //     },
                      //   )
                    ],
                  ),
                  // children: [
                  //   ContentArea(builder: (context, scroll) {
                  //     return IndexedStack(
                  //       index: pageIndex,
                  //       children: [
                  //         const TimerGrid(),
                  //         CustomScrollView(
                  //           controller: scroll,
                  //           slivers: const [
                  //             ProxyOptionsSlivers(),
                  //           ],
                  //         ),
                  //         const Center(child: Text('OSC Settings')),
                  //         const PreferencesView()
                  //       ],
                  //     );

                  //     // TimerGrid();
                  //   })
                  // ],
                // )),
      ),
    ));
  }
}
