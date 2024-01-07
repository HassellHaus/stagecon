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
        color: widget.cuelight.color,
        child: Center(
          child: AutoSizeText("GO ${(widget.cuelight.name ?? "").toUpperCase()}"),
        ),
      );
    } else {
      child= Container(
        decoration: BoxDecoration(
          color: widget.cuelight.color.withOpacity(0.4),
          border: Border.all(color: widget.cuelight.color, width: 10)
        ),
        child: Center(
          child: AutoSizeText("Standby ${widget.cuelight.name ?? ""}"),
        ),
      );
    }

    



    return DefaultTextStyle(style: TextStyle(fontSize: 400), child: child);
  }
}