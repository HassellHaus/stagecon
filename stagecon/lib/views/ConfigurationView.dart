import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:stagecon/views/AboutView.dart';
import 'package:stagecon/views/OSCLogView.dart';

class ConfigurationView extends StatefulWidget {
  const ConfigurationView({super.key});

  @override
  State<ConfigurationView> createState() => _ConfigurationViewState();
}

class _ConfigurationViewState extends State<ConfigurationView> {
  final info = NetworkInfo();
  
  late var expandableController = ExpandableController(initialExpanded: false);
  // expandableController
  late var deviceIP = NetworkInterface.list();
  // Future printIps() async {
  //   for (var interface in await NetworkInterface.list()) {
  //     print('== Interface: ${interface.name} ==');
  //     for (var addr in interface.addresses) {
  //       print(
  //           '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // printIps();
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: const CupertinoNavigationBar(previousPageTitle: "Back", middle: Text("Configuration")),
      child: SingleChildScrollView(
        
        child: Column(
          children: [
            SizedBox(height: 50 + MediaQuery.of(context).padding.top),
            
            CupertinoListSection.insetGrouped(
              // header: const Text("About"),
              children: [
                CupertinoListTile.notched(
                  leading: const Icon(CupertinoIcons.question_circle_fill),
                  title: const Text("About Stagecon"),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    //navigate to const AboutView() without get
                    Navigator.of(context, rootNavigator: false).push(
                      
                      MaterialPageRoute(builder: (context) => const AboutView()),
                    );

                    // Navigator.of(context, rootNavigator: true).push(
                    //         MaterialPageRoute(
                    //           // settings: RouteSettings(),
                    //           builder: (_) {
                    //             return MacosScaffold(
                    //               toolBar: const ToolBar(
                    //                 title: Text('New page'),
                    //               ),
                    //               children: [
                    //                 ContentArea(
                    //                   builder: (context, _) {
                    //                     return Center(
                    //                       child: PushButton(
                    //                         controlSize: ControlSize.regular,
                    //                         child: const Text('Go Back'),
                    //                         onPressed: () {
                    //                           Navigator.of(context).maybePop();
                    //                         },
                    //                       ),
                    //                     );
                    //                   },
                    //                 ),
                    //                 ResizablePane(
                    //                   minSize: 180,
                    //                   startSize: 200,
                    //                   windowBreakpoint: 700,
                    //                   resizableSide: ResizableSide.left,
                    //                   builder: (_, __) {
                    //                     return const Center(
                    //                       child: Text('Resizable Pane'),
                    //                     );
                    //                   },
                    //                 ),
                    //               ],
                    //             );
                    //           },
                    //         ),
                    //       );

                    
                  },
                )
              ],
            ),

            CupertinoListSection.insetGrouped(
              header: const Text("OSC Examples"),
              footer:  Text("You need an osc compatible program to send these.  This app was built with with QLab in mind.", style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel.resolveFrom(context) ),),
              children: const [
                CupertinoListTile.notched(title:  Text("Create/Edit a timer"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/[countdown|stopwatch]/set “Timer Name” ms s m h d ", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Reset a timer"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/timer/reset “Timer Name”", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Start/resume a timer"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/timer/start “Timer Name”", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Stop/pause a timer"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/timer/stop “Timer Name”", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Delete a timer"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/timer/delete “Timer Name”", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Delete all timers"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/timer/deleteAll", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Delete all countdowns or stopwatches"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/[countdown|stopwatch]/deleteAll", style: TextStyle(fontSize: 20),),)),
 
                CupertinoListTile.notched(title:  Text("Change a timer's color"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/timer/format/color \n “Timer Name” r[0-255] g[0-255] b[0-255] a[0-255]", maxLines: 2, style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Change the millisecond decimal precision"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/timer/format/msPrecision [0-3]", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Change countdown flash rate"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/timer/format/flashRate milliseconds(int)", style: TextStyle(fontSize: 20),),)),
                
                CupertinoListTile.notched(title:  Text("Send a message"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/message/post “Message Title” “Message Content” ttl(ms)", style: TextStyle(fontSize: 20),),)),

              ],
            ),

            //MARK: Network
            CupertinoListSection.insetGrouped(
              header: const Text("Network"),
              
              children: [
                const CupertinoListTile.notched(title: Text("Port"), subtitle: Text("4455"),),
                FutureBuilder(
                  future: deviceIP,
                  builder: (context, snapshot) {
                  if(snapshot.hasError) {

                    print(snapshot.error);
                    return const CupertinoListTile.notched(title: Text("Device IP"), subtitle: Text("Error getting addresses "));
                  }
                  
                  if(snapshot.hasData) {
                    
                    
                    List<Widget> featuredDeviceIps = [];
                    List<Widget> otherDeviceIps = [];

                    
                    for(var interface in snapshot.data!) {
                      for(var addr in interface.addresses) {
                        
                        if(interface.name == "en0" || interface.name == "wlan0") {
                          featuredDeviceIps.add(CupertinoListTile.notched(title: const Text("Device IP"), subtitle: FittedBox( fit: BoxFit.scaleDown, child: Text(addr.address)), additionalInfo: Text(interface.name),));
                        } else {
                          otherDeviceIps.add(CupertinoListTile.notched(title: const Text("Device IP"), subtitle: FittedBox( fit: BoxFit.scaleDown, child: Text(addr.address)), additionalInfo: Text(interface.name),));
                        }
                        // deviceIps.add(CupertinoListTile.notched(title: const Text("Device IP"), subtitle: FittedBox( fit: BoxFit.scaleDown, child: Text(addr.address)), additionalInfo: Text(interface.name),));
                      }
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                        mainAxisSize: MainAxisSize.min,
                        children: featuredDeviceIps,
                      ),
                      if(otherDeviceIps.isNotEmpty) Material(child: ExpandablePanel(
                        header: CupertinoListTile.notched(title: const Text("View All"), onTap: () => expandableController.toggle()),
                        collapsed: Container(),
                        expanded: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: otherDeviceIps,
                        ),
                        controller: expandableController,
                        theme: const ExpandableThemeData(
                          tapHeaderToExpand: true,
                          useInkWell: false,
                        // controller: ExpandableController(),
                      )
                      ))

                      ],
                    );
                  } else {
                    return const CupertinoListTile.notched(title: Text("Device IP"), subtitle: Text("Finding IP"));
                  }
                }),
                

                
              ],
            ),
            //MARK: Debug
            CupertinoListSection.insetGrouped(
              header: const Text("Tools"),
              children: [
                CupertinoListTile.notched(title: const  Text("OSC Log"), onTap: () => Get.to(()=> const OSCLogView()), trailing: const CupertinoListTileChevron(),),
              ],
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom,),
          ], 
        ),
      ),
    );
  }
}