// import 'package:flutter/cupertino.dart';
// import 'package:stagecon/widgets/cue_lights/cue_light_bulb.dart';

// class CueLightGrid extends StatelessWidget {
//   const CueLightGrid({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 5,
//       runSpacing: 5,
//       alignment: WrapAlignment.center,
//       // runAlignment: WrapAlignment.center,
//       children: [

//       SizedBox(
//         height: 100,
//         width: 100,
//         child: CueLightBulb(color: CupertinoColors.systemRed)),
//         SizedBox(
//         height: 100,
//         width: 100,
//         child: CueLightBulb(color: CupertinoColors.systemBlue)),
//         SizedBox(
//         height: 100,
//         width: 100,
//         child: CueLightBulb(color: CupertinoColors.systemGreen)),
//         SizedBox(
//         height: 100,
//         width: 100,
//         child: CueLightBulb(color: CupertinoColors.systemYellow)),
//         SizedBox(
//         height: 100,
//         width: 100,
//         child: CueLightBulb(color: CupertinoColors.systemCyan)),
//         SizedBox(
//         height: 100,
//         width: 100,
//         child: CueLightBulb(color: CupertinoColors.systemBrown)),
//         // SizedBox(
//         // height: 100,
//         // width: 100,
//         // child: CueLight(color: CupertinoColors.systemPurple)),
//       // Expanded(child: CueLight(color: CupertinoColors.systemBlue)),
//       // CueLight(color: CupertinoColors.systemGreen),
//       // CueLight(color: CupertinoColors.systemYellow),
//       // CueLight(color: CupertinoColors.systemCyan),
//       // CueLight(color: CupertinoColors.systemBrown),
//     ],);
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stagecon/types/sc_cuelight.dart';
import 'package:stagecon/widgets/cue_lights/cue_light_bulb.dart';
import 'package:stagecon/widgets/cue_lights/cue_light_intractable.dart';

class CueLightGrid extends StatelessWidget {
  const CueLightGrid({super.key, this.hideInactive = false});

  final bool hideInactive;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: Hive.box<ScCueLight>("cuelights").listenable(), builder: (context, cuelights, child) {
      var filtered = cuelights.values.where((element) => element.fromRemote == Hive.box("preferences").get("proxy_client_enabled"));
      
      return Wrap(
        spacing: 5,
        runSpacing: 5,
        // alignment: WrapAlignment.center,
        // runAlignment: WrapAlignment.center,
        children: filtered

          .where((element) => !hideInactive || element.state != CueLightState.inactive)
            .map((e) => SizedBox(
              height: 100,
              width: 100,
              child: CueLightIntractable(cueLight: e,)
            ))
            .toList());
    });
  }
}