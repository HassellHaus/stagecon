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


import 'dart:convert';

import 'package:get/get.dart';
import 'package:stagecon/controllers/OscController.dart';
import 'package:stagecon/types/server_message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerProxyClient {
    OSCcontroler oscCon = Get.find();
    late WebSocketChannel channel;
    ServerProxyClient({required Uri wsUrl}) {
      channel = WebSocketChannel.connect(wsUrl);
      print("Listening as client to $wsUrl");
      
      channel.stream.listen((message) {
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