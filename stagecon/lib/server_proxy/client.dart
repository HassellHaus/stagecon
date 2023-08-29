// import 'package:sse/client/sse_client.dart';

// class ServerProxyClient {
  
//   listen() async {
//     var channel = SseClient('http://192.168.1.223:5566/osc');

//     channel.stream.listen((s) {
//       // Listen for messages and send them back.
//       channel.sink.add(s);
//     });

//   }
// }


import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:stagecon/controllers/OscController.dart';
import 'package:stagecon/types/server_message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerProxyClient {
    OSCcontroler oscCon = Get.find();
    WebSocketChannel? channel;
    DateTime lastPing = DateTime.now();
    
    Timer? pingTimer; 

    Uri wsUrl;
    ServerProxyClient({required this.wsUrl}) {
      reconnect();
    }
      //check to see if we have recieved a ping in the last 1 mins
    _periodicPing(Timer timer) {
      if(DateTime.now().difference(lastPing) > Duration(minutes: 1)) {
        print("No ping in 1 minutes.  Reconnecting");
        reconnect();
        
      }
    }

    reconnect() {
      dispose();
      
      channel = WebSocketChannel.connect(wsUrl);
      print("Listening as client to $wsUrl");

      pingTimer = Timer.periodic(Duration(minutes: 1), _periodicPing);
      
      channel!.stream.listen((message) {
        if(message == "ping") {
          lastPing = DateTime.now();
          channel!.sink.add("pong");
          return;
        }
        print("Websocket: $message");
        try {
          final json = jsonDecode(message);
          final serverMessage = ServerMessage.fromJson(json);
          if(serverMessage.timerEvent != null) {
            // serverMessage.timerEvent.
            oscCon.callTimerEventListeners(serverMessage.timerEvent!);
          }

        } catch (e) {
          print(e);
        }
        // if(message)
        // channel.sink.add('received!');
        print(message);
        // channel.sink.close(status.goingAway);
      });
    }
  
    void dispose() {
      channel?.sink.close();
      channel?.stream.drain();
      pingTimer?.cancel();
      channel = null;
    }
    

    // listen() async {
    //   final wsUrl = Uri.parse('ws://192.168.1.223:5566');
    //   var channel = WebSocketChannel.connect(wsUrl);
    //   print("Listening as client to $wsUrl");
      
    //   channel.stream.listen((message) {
    //     channel.sink.add('received!');
    //     print(message);
    //     // channel.sink.close(status.goingAway);
    //   });

    //   // Future.delayed(const Duration(seconds: 5), () {
    //   //   print("saying Hey");
    //   //   channel.sink.add("Heyyy");
    //   // });

    // }
}