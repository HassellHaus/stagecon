import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stagecon/types/sc_cuelight.dart';

class CuelightFullscreenGrid extends StatelessWidget {
  const CuelightFullscreenGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<ScCueLight>("cuelights").listenable(),
        builder: (context, cuelights, child) {
          final filteredCuelights = cuelights.values
            .where((element) => 
                element.state == CueLightState.active 
                || element.state == CueLightState.acknowledged
                || element.state == CueLightState.standby    
            );
          
          int crossCount = filteredCuelights.isNotEmpty ? sqrt(filteredCuelights.length).ceil() : 1;
          // double aspect =  MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;

          // if(timers.length == 2) {
          //   crossCount = 1;
          //   aspect = MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height*0.5);
          // }

          return LayoutBuilder(builder: (context, constraints) {
            double aspect = constraints.maxWidth / constraints.maxHeight;
            print(constraints.minHeight);

            if (filteredCuelights.length == 2) {
              crossCount = 1;
              aspect = constraints.maxWidth / (constraints.maxHeight * 0.5);
            }
            return GridView.count(
                // shrinkWrap: true,
                crossAxisCount: crossCount,
                childAspectRatio: aspect,
                children: filteredCuelights.map((e) => 
                    _CueLightFullScreenBulb(cuelight: e,)
                  ).toList()
                  //sorting may make the watcher loose their place
                  // ..sort((a, b) {
                  //   //sort using the following qualities:
                  //   // active first, then acknowledged, then standby

                  //   if(a.cuelight.state == CueLightState.active) { 
                  //     return -1;
                  //   } else if(b.cuelight.state == CueLightState.active) {
                  //     return 1;
                  //   } else if(a.cuelight.state == CueLightState.acknowledged) {
                  //     return -1;
                  //   } else if(b.cuelight.state == CueLightState.acknowledged) {
                  //     return 1;
                  //   } else if(a.cuelight.state == CueLightState.standby) {
                  //     return -1;
                  //   } else if(b.cuelight.state == CueLightState.standby) {
                  //     return 1;
                  //   } else {
                  //     return 0;
                  //   }
                  // })
                 
                 
                );
          });
        });
  }
}


class _CueLightFullScreenBulb extends StatefulWidget {
  const _CueLightFullScreenBulb({super.key, required this.cuelight});

  final ScCueLight cuelight;

  @override
  State<_CueLightFullScreenBulb> createState() => __CueLightFullScreenBulbState();
}

class __CueLightFullScreenBulbState extends State<_CueLightFullScreenBulb> {
  @override
  Widget build(BuildContext context) {
    Widget child;
    if(widget.cuelight.state == CueLightState.active) {
      child= Container(
        color: widget.cuelight.color.withOpacity(0.95),
        child: Center(
          child: AutoSizeText("GO \n${(widget.cuelight.name ?? "").toUpperCase()}"),
        ),
      );
    } else {
      child= Container(
        decoration: BoxDecoration(
          color: widget.cuelight.color.withOpacity(0.4),
          border: Border.all(color: widget.cuelight.color, width: 10)
        ),
        child: Center(
          child: AutoSizeText("Standby \n${widget.cuelight.name ?? ""}"),
        ),
      );
    }

    



    return DefaultTextStyle(style: TextStyle(fontSize: 400), child: child);
  }
}