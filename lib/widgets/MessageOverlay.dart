import 'dart:ui';

import 'package:flutter/material.dart';

class MessageOverlay extends StatelessWidget {
  const MessageOverlay({super.key, required this.title, this.content});

  final String title;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
      padding: EdgeInsets.all(15),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white, fontSize: 300, fontFamily: "Roboto"),),
        if(content != null) Container(
          width: MediaQuery.of(context).size.width - 15,
          child: Text(content!,  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontSize: 150, fontFamily: "Roboto"),))
      ]),
    ))
    
    ) ;
    
  }
}