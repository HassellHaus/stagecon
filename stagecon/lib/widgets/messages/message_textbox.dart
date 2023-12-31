import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stagecon/types/sc_message.dart';

class MessageTextbox extends StatefulWidget {
  const MessageTextbox({super.key});

  @override
  State<MessageTextbox> createState() => _MessageTextboxState();
}

class _MessageTextboxState extends State<MessageTextbox> {
  var _controller = TextEditingController();


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void submit() async {
    var message = ScMessage(
      title: _controller.text, 
      // ttl: 
    );

    await message.upsert();
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: MacosColors.underPageBackgroundColor, child:
    Row(
      children: [
        MacosIconButton(icon: MacosIcon(CupertinoIcons.clock)),
        const SizedBox(width:4),
        Expanded(child: CupertinoTextField(
          onSubmitted: (_) =>  submit(),
          controller: _controller,
          placeholder: "Message",
          decoration: BoxDecoration(
            color: MacosColors.underPageBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: CupertinoColors.separator),
          ),
        )),
        CupertinoButton(
          child: Icon(CupertinoIcons.paperplane),
          onPressed: submit,
        )
      ],

    ));
  }
}