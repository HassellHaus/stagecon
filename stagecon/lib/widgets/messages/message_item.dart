import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stagecon/types/sc_message.dart';

var _pref = Hive.box("preferences");

class MessageItem extends StatelessWidget {
  const MessageItem({super.key, required this.message});

  final ScMessage message;

  @override
  Widget build(BuildContext context) {


    return Row(
      mainAxisAlignment: message.senderDeviceId==null
          ?MainAxisAlignment.center
          :message.senderDeviceId==_pref.get("device_id")
            ?MainAxisAlignment.end
            :MainAxisAlignment.start,
      children: [
    
    Container(
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(10),
        border: message.senderDeviceId!=null?null:Border.all(color: MacosColors.separatorColor),
      
      ),
      child: SelectionArea(child: 
      
      Column(
        mainAxisSize: MainAxisSize.min,
        
        mainAxisAlignment: MainAxisAlignment.center,
         

        children: [
          Flexible(child: 
          Padding(
            // padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: AutoSizeText(message.title, 
            // maxLines: 10,
            style: MacosTheme.of(context).typography.title3),
          )),
          if(message.content!=null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: AutoSizeText(message.content!, style: MacosTheme.of(context).typography.body),
          ),
        ],
      )
    ))
    
      ]);
  }
}