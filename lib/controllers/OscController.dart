
import 'package:get/get.dart';
import 'package:osc/osc.dart';
import 'package:stagecon/widgets/TimerDisplay.dart';

typedef TimerEventCallback = Function(String, TimerDisplayMode, Duration, bool);

class OSCcontroler extends GetxController{
  late OSCSocket socket;
  OSCcontroler({int port = 4455}) {
    socket = OSCSocket(serverPort: port);

    // try
    socket.listen((msg) {
      print("Recieved ${msg.address}");
      msg.arguments.forEach((element) {
        print(element);
        print(element.runtimeType);
      });

      if(msg.address.startsWith("/stagecon/stopwatch/")) {
        int argLen = msg.arguments.length;
        //this is a stagecon message
        print("Received stagecon stopwatch OSC message");
        try {
          if(msg.address.contains("set")) {
            //set command
            // print
            String id =  msg.arguments[0] as String;
            int ms =  argLen >1?(msg.arguments[1] as int? ?? 0):0;
            int s = argLen >2?(msg.arguments[2] as int? ?? 0):0;
            int m = argLen >3?(msg.arguments[3] as int? ?? 0):0;
            int h = argLen >4?(msg.arguments[4] as int? ?? 0):0;
            int d = argLen >5?(msg.arguments[5] as int? ?? 0):0;
            final duration = Duration(days: d, hours: h, minutes: m, seconds: s, milliseconds: ms);
            print(duration);

          }

        } catch (e) {
            print(e);
            Get.showSnackbar(GetSnackBar(
              title: "OSC Error: ${msg.address}",
              duration: const Duration(seconds: 3),
              message: e.toString(),
            ));
          }
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
  callTimerEventListeners(String id, TimerDisplayMode mode, Duration startDuration) {}


  void dispose() {
    
    socket.close();
  }
}