
import 'dart:ui';

import 'package:get/get.dart';
import 'package:stagecon/osc/osc.dart';

import 'package:stagecon/widgets/TimerDisplay.dart';

import '../widgets/MessageOverlay.dart';

typedef TimerEventCallback = Function(TimerEventOptions);
typedef OSCLogEventCallback = Function(OSCMessage);

enum TimerEventOperation {
  set,
  reset,
  start,
  stop,
  delete,
  format
}

enum TimerFormatOperation {
  color,
  msPrecision
}

class TimerEventOptions {
  final String? id;
  final TimerDisplayMode? mode;
  final Duration? startingAt;
  final bool? running;
  final TimerEventOperation operation;
  final String? subOperation;
  final dynamic extraData;
  // final Color? countdownColor
  const TimerEventOptions({
    this.id,
    required this.operation,
    this.mode,
    this.startingAt,
    this.running,
    this.extraData,
    this.subOperation
  });
}

class OSCcontroler extends GetxController{
  late OSCSocket socket;
  OSCcontroler({int port = 4455}) {
    socket = OSCSocket(serverPort: port);
    listen();

    
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

  Set<OSCLogEventCallback> logListeners = {};
  addLogEventListener(OSCLogEventCallback func) {
    logListeners.add(func);
  }
  removeLogEventListener(OSCLogEventCallback func) {
    logListeners.remove(func);
  }
  callLogEventListener(OSCMessage message) {
    logListeners.forEach((element) {element(message);});
  }

  ///Listen to osc messages.   
  void listen() {
    try{ 
      socket.close();
    } catch(e) {
      print("Osc listen() Could not close socket: $e");
    }
    socket.listen((msg) {
      callLogEventListener(msg);

      int argLen = msg.arguments.length;

      try {
        bool stopwatchCommand = msg.address.startsWith("/stagecon/stopwatch"); // offset 19
        bool countdownCommand = msg.address.startsWith("/stagecon/countdown"); // offset 19;
        TimerDisplayMode timerMode = stopwatchCommand?TimerDisplayMode.stopwatch:TimerDisplayMode.countdown;

        bool timerCommand = msg.address.startsWith("/stagecon/timer"); // offset:15 
        
        //set command
        if((stopwatchCommand || countdownCommand) && msg.address.contains("/set",19)) {
          
          String id =  msg.arguments[0] as String;

          
          //split the arguments out into the time components
          int ms =  argLen >1?(msg.arguments[1] as int? ?? 0):0;
          int s = argLen >2?(msg.arguments[2] as int? ?? 0):0;
          int m = argLen >3?(msg.arguments[3] as int? ?? 0):0;
          int h = argLen >4?(msg.arguments[4] as int? ?? 0):0;
          int d = argLen >5?(msg.arguments[5] as int? ?? 0):0;
          final duration = Duration(days: d, hours: h, minutes: m, seconds: s, milliseconds: ms);
          // print(duration);

          callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.set, startingAt: duration, mode: timerMode));
        } 
        //MARK: Delete All Command
        else if((stopwatchCommand || countdownCommand || timerCommand) && msg.address.contains("/deleteAll",15)) { // offset of 16 because the timer is shorter than the other two commands
          callTimerEventListeners(TimerEventOptions(operation: TimerEventOperation.delete,  mode: timerCommand?null:timerMode));
        }

        //MARK: all timer commands
        else if(timerCommand) {
          String id =  msg.arguments[0] as String;
          if(msg.address.contains("/start",15)) {
            callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.start));
          } else if (msg.address.contains("/start",15)) {
            callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.start));
          } else if (msg.address.contains("/stop",15)) {
            callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.stop));
          } else if (msg.address.contains("/reset",15)) {
            callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.reset));
          } else if (msg.address.contains("/delete",15)) {
            callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.delete));
          } else if (msg.address.contains("/format",15)) {
            //TODO: Format sub-commands go here.
            if(msg.address.contains("/color",22)) {
              Color parsedColor = Color.fromARGB(
                argLen >4?(msg.arguments[4] as int? ?? 255):255,
                argLen >1?(msg.arguments[1] as int? ?? 0):0,
                argLen >2?(msg.arguments[2] as int? ?? 0):0,
                argLen >3?(msg.arguments[3] as int? ?? 0):0
              );
              // Send a color update
              callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.format, subOperation: "color", extraData: parsedColor));
            }
            else if(msg.address.contains("/msPrecision",22)) {
              // millisecond precision
              int precision = argLen >1?(msg.arguments[1] as int? ?? 0):0;

              callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.format, subOperation: "msPrecision", extraData: precision));
            }
            else if(msg.address.contains("/flashRate",22)) {
              int flashRate = argLen >1?(msg.arguments[1] as int? ?? 500):500;
              callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.format, subOperation: "flashRate", extraData: flashRate));
            }
            // callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.format,));
          } else {
            Get.showSnackbar(GetSnackBar(
              title: "OSC Error: ${msg.address}",
              duration: const Duration(seconds: 3),
              message: "Unknown Operation",
            ));
          }
        }

        //MARK: Messages
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

        //mark: Setting 

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

  void dispose() {
    
    socket.close();
  }
}