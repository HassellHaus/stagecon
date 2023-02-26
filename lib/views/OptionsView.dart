import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:network_info_plus/network_info_plus.dart';

class OptionsView extends StatefulWidget {
  const OptionsView({super.key});

  @override
  State<OptionsView> createState() => _OptionsViewState();
}

class _OptionsViewState extends State<OptionsView> {
  final info = NetworkInfo();

  late var deviceIP = NetworkInterface.list();
  Future printIps() async {
    for (var interface in await NetworkInterface.list()) {
      print('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        print(
            '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    printIps();
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(previousPageTitle: "Back", middle: Text("Options")),
      child: SingleChildScrollView(
        
        child: Column(
          children: [
            SizedBox(height: 50 + MediaQuery.of(context).padding.top),

            CupertinoListSection.insetGrouped(
              header: const Text("OSC Examples"),
              footer:  Text("You need an osc compatible program to send these.  This app was built with the intent to use it with QLab", style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel.resolveFrom(context) ),),
              children: const [
                CupertinoListTile.notched(title:  Text("Create/Edit a timer"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/[countdown|stopwatch]/set “Timer Name” ms s m h d ", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Reset a timer"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/[countdown|stopwatch]/reset “Timer Name”", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Start/resume a timer"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/[countdown|stopwatch]/start “Timer Name”", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Stop/pause a timer"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/[countdown|stopwatch]/stop “Timer Name”", style: TextStyle(fontSize: 20),),)),
                CupertinoListTile.notched(title:  Text("Delete a timer"), subtitle: FittedBox( fit: BoxFit.scaleDown, child:  Text("/stagecon/[countdown|stopwatch]/delete “Timer Name”", style: TextStyle(fontSize: 20),),)),

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
                    return CupertinoListTile.notched(title: Text("Device IP"), subtitle: const Text("Error getting addresses "));
                  }
                  
                  if(snapshot.hasData) {
                    List<Widget> deviceIps = [];
                    for(var interface in snapshot.data!) {
                      for(var addr in interface.addresses) {
                        
                        deviceIps.add(CupertinoListTile.notched(title: Text("Device IP"), subtitle: FittedBox( fit: BoxFit.scaleDown, child: Text(addr.address)), additionalInfo: Text(interface.name),));
                      }
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: deviceIps,
                    );
                  } else {
                    return const CupertinoListTile.notched(title: Text("Device IP"), subtitle: const Text("Finding IP"));
                  }
                }),
                

                
              ],
            )
          ], 
        ),
      ),
    );
  }
}