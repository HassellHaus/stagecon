import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class NetworkInfoListSection extends StatefulWidget {
  const NetworkInfoListSection({super.key});

  @override
  State<NetworkInfoListSection> createState() => _NetworkInfoListSectionState();
}

class _NetworkInfoListSectionState extends State<NetworkInfoListSection> {

  final info = NetworkInfo();
  
  late var expandableController = ExpandableController(initialExpanded: false);
  // expandableController
  late var deviceIP = NetworkInterface.list();

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      backgroundColor: const Color(0x00000000),
      header: const Text("Network"),
      children: [
        FutureBuilder(
            future: deviceIP,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return const CupertinoListTile.notched(
                    title: Text("Device IP"), subtitle: Text("Error getting addresses "));
              }

              if (snapshot.hasData) {
                List<Widget> featuredDeviceIps = [];
                List<Widget> otherDeviceIps = [];

                for (var interface in snapshot.data!) {
                  for (var addr in interface.addresses) {
                    if (interface.name == "en0" || interface.name == "wlan0") {
                      featuredDeviceIps.add(CupertinoListTile.notched(
                        title: const Text("Device IP"),
                        subtitle: FittedBox(fit: BoxFit.scaleDown, child: Text(addr.address)),
                        additionalInfo: Text(interface.name),
                      ));
                    } else {
                      otherDeviceIps.add(CupertinoListTile.notched(
                        title: const Text("Device IP"),
                        subtitle: FittedBox(fit: BoxFit.scaleDown, child: Text(addr.address)),
                        additionalInfo: Text(interface.name),
                      ));
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
                    if (otherDeviceIps.isNotEmpty)
                      Material(
                          color: const Color(0x00000000),
                          child: ExpandablePanel(
                              header: CupertinoListTile.notched(
                                  title: const Text("View All"), onTap: () => expandableController.toggle()),
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
                              )))
                  ],
                );
              } else {
                return const CupertinoListTile.notched(title: Text("Device IP"), subtitle: Text("Finding IP"));
              }
            }),
      ],
    );
  }
}
