import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stagecon/types/sc_message.dart';
import 'package:stagecon/widgets/messages/message_item.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset.zero).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<ScMessage>("messages").listenable(),
      builder: (context, messages, child) {
        var sorted = messages.values.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return SliverList.builder(
          itemBuilder: (context, index) {
            final message = sorted[index];
            final isNewestMessage = index == 0;

            if (isNewestMessage) {
              print("Newest Message: ${message.title}");
              _animationController.reset(); // Reset the animation controller
              _animationController.forward(); // Start the animation from the beginning
              return FadeTransition(
                  opacity: _opacityAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: MessageItem(message: message),
                  ));
            }

            return MessageItem(message: message);

            // return AnimatedOpacity(
            //   opacity: isNewestMessage ? _opacityAnimation.value : 1.0,
            //   duration: Duration(milliseconds: 500),
            //   child: SlideTransition(
            //     position: isNewestMessage ? _slideAnimation : AlwaysStoppedAnimation(Offset.zero),
            //     child: MessageItem(message: message),
            //   ),
            // );
          },
          itemCount: sorted.length,
        );
      },
    );
  }
}
