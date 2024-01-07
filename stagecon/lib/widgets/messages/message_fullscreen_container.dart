// import 'package:flutter/cupertino.dart';
// ///Watches for messages and displays them in a fullscreen overlay. 
// ///Will move the child to hte right to make room for the message
// ///will display messages with the newest at the top  
// ///when all messages are cleared or their ttl expires animate the child back to full width
// class MessageFullScreenContainer extends StatefulWidget {
//   const MessageFullScreenContainer({super.key, required this.child});

//   final Widget child;

//   @override
//   State<MessageFullScreenContainer> createState() => _MessageFullScreenContainerState();
// }

// class _MessageFullScreenContainerState extends State<MessageFullScreenContainer> {
//   @override
//   Widget build(BuildContext context) {
    
//     ValueListenableBuilder(
//       valueListenable: Hive.box<ScMessage>("messages").listenable(),
//       builder: (context, messages, child) {


//   }
// }