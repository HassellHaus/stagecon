
import 'package:get/get.dart';
import 'package:osc/osc.dart';
import 'package:stagecon/widgets/TimerDisplay.dart';

import '../widgets/MessageOverlay.dart';

typedef TimerEventCallback = Function(TimerEventOptions);

enum TimerEventOperation {
  set,
  reset,
  start,
  stop,
  delete,
  format
}

class TimerEventOptions {
  final String id;
  final TimerDisplayMode? mode;
  final Duration? startingAt;
  final bool? running;
  final TimerEventOperation operation;
  const TimerEventOptions({
    required this.id,
    required this.operation,
    this.mode,
    this.startingAt,
    this.running
  });
}

class OSCcontroler extends GetxController{
  late OSCSocket socket;
  OSCcontroler({int port = 4455}) {
    socket = OSCSocket(serverPort: port);

    // try
    socket.listen((msg) {
      // print("Recieved ${msg.address}");
      // msg.arguments.forEach((element) {
      //   print(element);
      //   print(element.runtimeType);
      // });
      int argLen = msg.arguments.length;
      bool stopwatchCommand = msg.address.startsWith("/stagecon/stopwatch/");
      bool countdownCommand = msg.address.startsWith("/stagecon/countdown/");
      bool messageCommand = msg.address.startsWith("/stagecon/message/");
      try {
        if(countdownCommand || stopwatchCommand) {
          
          //this is a stagecon message
          print("Received stagecon stopwatch OSC message");
          
            TimerDisplayMode mode = stopwatchCommand?TimerDisplayMode.stopwatch:TimerDisplayMode.countdown;
            
            String id =  msg.arguments[0] as String;
            if(msg.address.contains("/set")) {
              //set command
              // print
              
              int ms =  argLen >1?(msg.arguments[1] as int? ?? 0):0;
              int s = argLen >2?(msg.arguments[2] as int? ?? 0):0;
              int m = argLen >3?(msg.arguments[3] as int? ?? 0):0;
              int h = argLen >4?(msg.arguments[4] as int? ?? 0):0;
              int d = argLen >5?(msg.arguments[5] as int? ?? 0):0;
              final duration = Duration(days: d, hours: h, minutes: m, seconds: s, milliseconds: ms);
              print(duration);

              callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.set, startingAt: duration, mode: mode));
            } else if (msg.address.contains("/start",19)) {
              callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.start));
            } else if (msg.address.contains("/stop",19)) {
              callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.stop));
            } else if (msg.address.contains("/reset",19)) {
              callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.reset));
            } else if (msg.address.contains("/delete",19)) {
              callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.delete));
            } else if (msg.address.contains("/format",19)) {
              callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.format, ));
            } else {
              Get.showSnackbar(GetSnackBar(
                title: "OSC Error: ${msg.address}",
                duration: const Duration(seconds: 3),
                message: "Unknown Operation",
              ));
            }

          
        }

        if(msg.address.startsWith("/stagecon/message")) {
          print("GOT MESSAGE");
          //message command
          if(argLen == 0) {
            throw Exception("Message must have a title.  /stagecon/message/ \"SOME TITLE\"");
          }
          String title = msg.arguments[0] as String;
          String? content =  argLen >1?msg.arguments[1] as String:null;
          int ttl = argLen >2 ?msg.arguments[2] as int:3000;
          Get.showOverlay(asyncFunction: ()=>Future.delayed(Duration(milliseconds: ttl)), loadingWidget: MessageOverlay(title: title, content: content), opacity: 0.8 );
          
        }

      } catch (e) {
            print(e);
            Get.showSnackbar(GetSnackBar(
              title: "OSC Error: ${msg.address}",
              duration: const Duration(seconds: 3),
              message: e.toString(),
            ));
          }
      // socket.reply(OSCMessage('/received', arguments: []));
    });
    
  }
  
  Set<TimerEventCallback> timerListeners = {};
  addTimerEventListener(TimerEventCallback func) {
    timerListeners.add(func);
  }
  removeTimerEventListener(TimerEventCallback func) {
    timerListeners.remove(func);
  }
  callTimerEventListeners(TimerEventOptions options) {
    // print("HI");
    timerListeners.forEach((element) {element(options);});
  }


  void dispose() {
    
    socket.close();
  }
}