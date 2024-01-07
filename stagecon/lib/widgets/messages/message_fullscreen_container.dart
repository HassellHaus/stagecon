import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stagecon/types/sc_message.dart';
///Watches for messages and displays them in a fullscreen overlay. 
///Will move the child to hte right to make room for the message
///will display messages with the newest at the top  
///when all messages are cleared or their ttl expires animate the child back to full width
class MessageFullScreenContainer extends StatefulWidget {
  const MessageFullScreenContainer({super.key, required this.child});

  final Widget child;

  @override
  State<MessageFullScreenContainer> createState() => _MessageFullScreenContainerState();
}

class _MessageFullScreenContainerState extends State<MessageFullScreenContainer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late CurvedAnimation _curvedAnimation;
  bool isOpen = false;

  List<Timer> ttlTimers = [];

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
   _curvedAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut); 
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _curvedAnimation.dispose();
    for (var element in ttlTimers) { element.cancel();}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(CupertinoTheme.brightnessOf(context));
    
    return ValueListenableBuilder(
      valueListenable: Hive.box<ScMessage>("messages").listenable(),
      builder: (context, messages, child) {
        ttlTimers.clear();

        //sort by newest message 
        //then find the messages that are not ttl expired
        var filteredMessages = messages.values
          .where((element) => !element.ttlExpired,).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        
        //set a timer for each message to reload the widget when it expires, using created at as the epoch time
        for (var message in filteredMessages) {
          DateTime expireAt = message.createdAt.add(message.ttl);
          Duration timeTillExpire = expireAt.difference(DateTime.now());
          
          var timer = Timer(timeTillExpire, () {
            setState(() {});
          });
          ttlTimers.add(timer);
        }


        //if there are no messages or all messages are ttl expired
        //close the overlay and animate the child back to full width
        //if the isOpen flag is set to false and the messages are not empty
        //then open the overlay and animate the child to the right

        if(filteredMessages.isEmpty) {
          if(isOpen) {
            isOpen = false;
            _animationController.reverse();
          }
        } else {
          if(!isOpen) {
            isOpen = true;
            _animationController.forward();
          }
        }

        return LayoutBuilder(builder: (context, constraints) {
            final widthFactor = max(250, constraints.maxWidth*0.3);
            return Stack(
            children: [
              AnimatedBuilder(
                animation: _curvedAnimation,
                builder: (context, _) {
                  // Adjust the child position based on the animation
                  return SizedBox(
                      width: constraints.maxWidth - (_curvedAnimation.value * widthFactor),
                      child: widget.child
                    );
                  // return Transform.translate(
                  //   offset: Offset(_curvedAnimation.value * widthFactor, 0), // Example offset
                  //   child: SizedBox(
                  //     width: constraints.maxWidth - (_curvedAnimation.value * widthFactor),
                  //     child: widget.child
                  //   ),
                  // );
                },
              ),
              //Messages Panel
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                child: DefaultTextStyle(
                  style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontSize: 100,
                    color: CupertinoColors.label.resolveFrom(context)
                  ),
                  child:
                
                AnimatedBuilder(
                  animation: _curvedAnimation,
                  builder: (context, _) {
                    // This builds the sliding message list
                    return Container(
                      width: _curvedAnimation.value * widthFactor, // Example width
                      color: CupertinoColors.systemGroupedBackground.resolveFrom(context), // Example background color
                      child: ListView.builder(
                        itemCount: filteredMessages.length,
                        itemBuilder: (context, index) {
                          ScMessage message = filteredMessages[index];
                          // Message Container
                          return Container(
                            color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoSizeText(message.title, maxLines: 10,),
                                if(message.content !=null) AutoSizeText(message.content!),
                            ],)
                          );
                        },
                      ),
                    );
                  },
                )),
              ),
            ],
          );

        });
        
        
        
      }, child: widget.child);


  }
}