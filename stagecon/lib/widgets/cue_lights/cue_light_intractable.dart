import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stagecon/types/sc_cuelight.dart';
import 'package:stagecon/widgets/cue_lights/cue_light_bulb.dart';

///THis wraps the cue light bulb with data with an object that allows for interactions on the passed in cue light
///

class CueLightIntractable extends StatelessWidget {
  const CueLightIntractable({super.key, required this.cueLight});

  final ScCueLight cueLight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: 
        GestureDetector(
      onTapDown: (_) {
        print("Pushed Cuelight: ${cueLight.id} ");
        switch(cueLight.state) {
          
          case CueLightState.inactive:
            cueLight.state = CueLightState.standby;
          case CueLightState.standby:
            cueLight.state = CueLightState.active;
          case CueLightState.acknowledged: 
            cueLight.state = CueLightState.active;
          case CueLightState.active:
            cueLight.state = CueLightState.inactive;
        }
        print("Cuelight state is now: ${cueLight.state}");
        cueLight.upsert();
      },

      onTapUp: (details) {
        print("Released Cuelight: ${cueLight.id} ");
        if(cueLight.state == CueLightState.active && !cueLight.toggleActive) {
          cueLight.state = CueLightState.inactive;
          cueLight.upsert();
        }
      
      },

    child: 
    Semantics(
    
      onTapHint: "Push to toggle ${cueLight.name??cueLight.id}",
      child: CueLightBulb(color: cueLight.color, state: cueLight.state)
    ))),

      //Cancel Button


      //Name
        Positioned.fill(
          
          child: IgnorePointer(child: Center(child: Container(
            decoration: BoxDecoration(
              // color: CupertinoColors.systemGrey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(100)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(cueLight.name??cueLight.id, style: TextStyle(color: CupertinoColors.white),),
            ),
          ))),
        ),

        if(cueLight.state == CueLightState.standby)Positioned(child: MacosIconButton(
          backgroundColor: MacosColors.controlBackgroundColor.resolveFrom(context),
          borderRadius: BorderRadius.circular(100),
          semanticLabel: "Cancel Standby for ${cueLight.name??cueLight.id}",
          icon: MacosIcon(CupertinoIcons.clear),
          onPressed: () {
            if(cueLight.state == CueLightState.standby) {
              cueLight.state = CueLightState.inactive;
              cueLight.upsert();
            }
          },
        ),)
        
      ],
    );
    
    
    
    
  }
}