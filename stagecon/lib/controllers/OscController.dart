
import 'dart:ui';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:stagecon/osc/osc.dart';
import 'package:stagecon/types/sc_cuelight.dart';
import 'package:stagecon/types/sc_message.dart';
import 'package:stagecon/types/sc_timer.dart';


import '../widgets/MessageOverlay.dart';

// typedef TimerEventCallback = Function(TimerEventOptions);
typedef OSCLogEventCallback = Function(OSCMessage);
// typedef MessageEventCallback = Function(MessageEvent);



class OSCcontroler extends GetxController{
  OSCSocket? socket;
  int port = 4455;
  OSCcontroler({this.port = 4455}) {
    // socket = OSCSocket(serverPort: port);
    // socket = OSCSocket(serverPort: port);
    listen();

    

    
  }
  
  // Set<TimerEventCallback> timerListeners = {};
  // addTimerEventListener(TimerEventCallback func) {
  //   timerListeners.add(func);
  // }
  // removeTimerEventListener(TimerEventCallback func) {
  //   timerListeners.remove(func);
  // }
  // callTimerEventListeners(TimerEventOptions options) {
  //   // print("HI");
  //   timerListeners.forEach((element) {element(options);});
  // }

  //   Set<MessageEventCallback> messageListeners = {};
  //   addMessageEventListener(MessageEventCallback func) {
  //     messageListeners.add(func);
  //   }
  //   removeMessageEventListener(MessageEventCallback func) {
  //     messageListeners.remove(func);
  //   }
  //   callMessageEventListeners(MessageEvent options) {
  //     // print("HI");
  //     messageListeners.forEach((element) {element(options);});
  //   }

  Set<OSCLogEventCallback> logListeners = {};
  addLogEventListener(OSCLogEventCallback func) {
    logListeners.add(func);
  }
  removeLogEventListener(OSCLogEventCallback func) {
    logListeners.remove(func);
  }
  callLogEventListener(OSCMessage message) {
    for (var element in logListeners) {element(message);}
  }
  /// Parses out an OSC message
  parse(OSCMessage msg) async {
    print(msg);
      callLogEventListener(msg);

      int argLen = msg.arguments.length;
      
      try {
        bool stopwatchCommand = msg.address.startsWith("/stagecon/stopwatch"); // offset 19
        bool countdownCommand = msg.address.startsWith("/stagecon/countdown"); // offset 19;
        TimerMode timerMode = stopwatchCommand?TimerMode.stopwatch:TimerMode.countdown;

        bool timerCommand = msg.address.startsWith("/stagecon/timer"); // offset:15 
        
        
        //MARK: set command
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

          // TimerEventStore.instance.upsert(id: id, startingAt: duration, mode: timerMode);
          // final 
          // callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.set, startingAt: duration, mode: timerMode));
          //get existing timer (if it exists)
          ScTimer? existingTimer = ScTimer.get("local_$id") ?? ScTimer();

          existingTimer.id = id;
          existingTimer.initialStartingAt = duration;
          existingTimer.mode = timerMode;

          await existingTimer.upsert();
        
        } 
        //MARK: Delete All Command
        else if((stopwatchCommand || countdownCommand || timerCommand) && msg.address.contains("/deleteAll",15)) { // offset of 16 because the timer is shorter than the other two commands
          // TimerEventStore.instance.value = {};
          Hive.box<ScTimer>("timers").clear();
        }

        //MARK: all timer commands
        else if(timerCommand) {
          String id =  msg.arguments[0] as String;
          ScTimer? existingTimer = ScTimer.get("local_$id");
          if(existingTimer == null) {
            throw Exception("Unknown timer id: $id");
            
          }
          if(msg.address.contains("/start",15)) {
            existingTimer.running = true;
            await existingTimer.upsert();
            // TimerEventStore.instance.upsert(ScTimerEvent(id: id, running: true, createdAt: DateTime.timestamp()));
            // callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.start, epochTime: DateTime.now()));
          // } else if (msg.address.contains("/start",15)) {
          //   callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.start, epochTime: DateTime.now()));
          } else if (msg.address.contains("/stop",15)) {
            existingTimer.running = false;
            await existingTimer.upsert();
            // TimerEventStore.instance.upsert(ScTimerEvent(id: id, running: false, createdAt: DateTime.timestamp()));
            // callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.stop));
          } else if (msg.address.contains("/reset",15)) {
            existingTimer.reset();
            await existingTimer.upsert();
            // TimerEventStore.instance.upsert(ScTimerEvent(id: id, createdAt: DateTime.timestamp()));
            // callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.reset));
          } else if (msg.address.contains("/delete",15)) {
            ScTimer.delete(existingTimer.dbId);
            // TimerEventStore.instance.value.removeWhere((key, value) => key == id);
            // callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.delete));
          } else if (msg.address.contains("/format",15)) {
            //TODO: Format sub-commands go here.
            if(msg.address.contains("/color",22)) {
              Color parsedColor = Color.fromARGB(
                argLen >4?(msg.arguments[4] as int? ?? 255):255,
                argLen >1?(msg.arguments[1] as int? ?? 0):0,
                argLen >2?(msg.arguments[2] as int? ?? 0):0,
                argLen >3?(msg.arguments[3] as int? ?? 0):0
              );
              existingTimer.color = parsedColor;
              await existingTimer.upsert();
              // Send a color update
              // TimerEventStore.instance.upsert(ScTimerEvent(id: id, color: parsedColor));
              // callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.format, subOperation: "color", extraData: parsedColor));
            }
            else if(msg.address.contains("/msPrecision",22)) {
              // millisecond precision
              int precision = argLen >1?(msg.arguments[1] as int? ?? 0):0;
              existingTimer.msPrecision = precision;
              await existingTimer.upsert();

              // callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.format, subOperation: "msPrecision", extraData: precision));
            }
            else if(msg.address.contains("/flashRate",22)) {
              int flashRate = argLen >1?(msg.arguments[1] as int? ?? 500):500;
              existingTimer.flashRate = flashRate;
              await existingTimer.upsert();
              // callTimerEventListeners(TimerEventOptions(id: id, operation: TimerEventOperation.format, subOperation: "flashRate", extraData: flashRate));
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
        if(msg.address.startsWith("/stagecon/message")) { // offset: 17
          //Post Message
          if(msg.address.contains("/post",17)) {
            print("GOT MESSAGE");
            //message command
            if(argLen == 0) {
              throw Exception("Message must have a title.  /stagecon/message/post \"SOME TITLE\"");
            }
            String title = msg.arguments[0] as String;
            String? content =  argLen >1?msg.arguments[1] as String:null;
            int ttl = argLen >2 ?msg.arguments[2] as int:3000;

            ScMessage message = ScMessage(
              // id: "osc_$title",
              senderDeviceId: "OSC",
              senderName: "System",
              title: title, 
              content: content, 
              ttl: Duration(milliseconds: ttl)
            );
            await message.upsert();
          // Get.showOverlay(asyncFunction: ()=>Future.delayed(Duration(milliseconds: ttl)), loadingWidget: MessageOverlay(title: title, content: content), opacity: 0.8 );
          } else {
            Get.showSnackbar(GetSnackBar(
              title: "OSC Error: ${msg.address}",
              duration: const Duration(seconds: 3),
              message: "Unknown Message Operation",
            ));
          }
        }

        //MARK: Cuelights
        if(msg.address.startsWith("/stagecon/cuelight")) { // offset: 18

        
        //update cuelight state
          if(msg.address.contains("/state",18)) { /// "cuelight id" "state"

            if(argLen < 2) {
              throw Exception("Cuelight must have an id and a state.  /stagecon/cuelight/state \"SOME ID\" [inactive|standby|active]");
            }
            String id = msg.arguments[0] as String;
            String state = msg.arguments[1] as String;

            ScCueLight? existingCueLight = ScCueLight.get("local_$id");

            if(existingCueLight == null) {
              throw Exception("Unknown cuelight id: $id");
            }

            if(state == "inactive") {
              existingCueLight.state = CueLightState.inactive;
            } else if(state == "standby") {
              existingCueLight.state = CueLightState.standby;
            } else if(state == "active") {
              existingCueLight.state = CueLightState.active;
            } else {
              throw Exception("Unknown cuelight state: $state");
            }

            await existingCueLight.upsert();

          }
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

  }

  ///Listen to osc messages.   
  void listen() {
    try{ 
      socket?.close();
      socket = OSCSocket(serverPort: port);
      print("Listening on port $port");
    } catch(e) {
      print("Osc listen() Could not close socket: $e");
      rethrow;
    }
    
    socket!.listen((msg) {
      // socket.reply(OSCMessage('/received', arguments: []));
      parse(msg);
    });
  }
  @override
  void dispose() {
    socket?.close();
    super.dispose(); 
  }
}