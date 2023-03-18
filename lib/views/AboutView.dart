import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:stagecon/views/AcknowledgementsView.dart';
import 'package:stagecon/widgets/OtherApps.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(style: CupertinoTheme.of(context).textTheme.textStyle, child: CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(),
      child: SingleChildScrollView(child: Column(children: [
        SizedBox(height: 80 + MediaQuery.of(context).padding.top),
        //Logo 
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Image.asset("assets/icon/rounded.png")
          ),
          SizedBox(width: MediaQuery.of(context).size.width),
          const Text("Stagecon", style: TextStyle(fontSize: 40),)

        ],),

        CupertinoListSection.insetGrouped(
          header: const Text("Developer"),
          children: [
            CupertinoListTile.notched(         
              leading: const Icon(CupertinoIcons.person_fill),
              title: const Text('Developed by Joseph Hassell'),
              subtitle: const Text("at HassellHaus LLC"),
              trailing: const CupertinoListTileChevron(),
              onTap: () => launchUrlString("https://joseph.hassell.dev")
            ),

            CupertinoListTile.notched(         
              leading: const Icon(CupertinoIcons.building_2_fill),
              title: const Text('HassellHaus LLC'),
              trailing: const CupertinoListTileChevron(),
              onTap: () => launchUrlString("https://hassell.haus"),
            ),
            

            const CupertinoListTile.notched(         
              //leading: const Icon(CupertinoIcons.building_2_fill),
              title: Text('Made with ❤️'),
            ),

          ]),


        CupertinoListSection.insetGrouped(
          children: [
            CupertinoListTile.notched(title: const Text("Big thanks to Connor Kordes"), subtitle: const Text("for fixing a critical bug with the OSC library"), trailing: const CupertinoListTileChevron(), additionalInfo: const Text("Github"), onTap:() => launchUrlString("https://github.com/M0nster5"),),
            CupertinoListTile.notched(title: const Text("Open Source Licenses"), trailing: const CupertinoListTileChevron(), onTap: () => Get.to(()=> const AcknowledgementsView()),)
          ],
        ),

        // const OtherApps()
        
      ],)),
    ));
  }
}