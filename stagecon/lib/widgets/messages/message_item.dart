import 'package:flutter/cupertino.dart';
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
        color: MacosColors.underPageBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: message.senderDeviceId!=null?null:Border.all(color: MacosColors.separatorColor),
      
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        
        mainAxisAlignment: MainAxisAlignment.center,
         

        children: [
          Padding(
            // padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(message.title, style: MacosTheme.of(context).typography.title3),
          ),
          if(message.content!=null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(message.content!, style: MacosTheme.of(context).typography.body),
          ),
        ],
      )
    )
    
      ]);
  }
}