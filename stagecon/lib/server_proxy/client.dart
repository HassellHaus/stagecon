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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stagecon/controllers/OscController.dart';
import 'package:stagecon/types/sc_cuelight.dart';
import 'package:stagecon/types/sc_message.dart';
import 'package:stagecon/types/sc_timer.dart';
import 'package:stagecon/types/server_message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ScProxyClient {
    OSCcontroler oscCon = Get.find();
    WebSocketChannel? channel;
    DateTime lastPing = DateTime.now();

    // var timerBox = Hive.box<ScTimer>('timers');
    ValueNotifier<bool> isConnected = ValueNotifier(false);

    StreamSubscription<dynamic>? wsStream;
    
    Timer? pingTimer; 

    Uri? wsUrl;
    ScProxyClient() {
      // reconnect();
    }
      //check to see if we have recieved a ping in the last 1 mins
    _periodicPing(Timer timer) {
      if(DateTime.now().difference(lastPing) > const Duration(minutes: 1)) {
        print("No ping in 1 minutes.  Reconnecting");
        isConnected.value = false;
        reconnect(wsUrl: wsUrl!);
      }
    }
    // List test = [];
    reconnect({required Uri wsUrl}) async {
      this.wsUrl = wsUrl;
      disconnect();

      try {
        channel = WebSocketChannel.connect(wsUrl);
        await channel!.ready;
        print("Connected to $wsUrl");
        // channel.
      } catch (e) {
        print("Failed to connect to $wsUrl");
        print(e);
        return;
      }
      
      print("Listening as client to $wsUrl");

      isConnected.value = true;

      pingTimer = Timer.periodic(const Duration(minutes: 1), _periodicPing);
      
      wsStream = channel!.stream.listen((message) {
        if(message == "ping") {
          lastPing = DateTime.now();
          channel!.sink.add("pong");
          return;
        }
        print("Websocket: $message");
        try {
          //MARK: Decode incoming timers & messagers
          final json = jsonDecode(message);
          final serverMessage = ServerMessage.fromJson(json);
          //MARK: Timer
          if(serverMessage.dataType == ServerMessageDataType.timer) {
            // serverMessage.timerEvent.
            if(serverMessage.method == ServerMessageMethod.upsert) {
              //convert to object
              var timer = ScTimer.fromJson(serverMessage.data!);
              timer.fromRemote = true;
              timer.upsert();
            } else if(serverMessage.method == ServerMessageMethod.delete) {
              ScTimer.delete(serverMessage.target);
            }
          }

          // //MARK: Messages
          if(serverMessage.dataType == ServerMessageDataType.message) {
            // serverMessage.timerEvent.
            if(serverMessage.method == ServerMessageMethod.upsert) {
              //convert to object
              var message = ScMessage.fromJson(serverMessage.data!);
              message.fromRemote = true;
              message.upsert();
            } else if(serverMessage.method == ServerMessageMethod.delete) {
              ScMessage.delete(serverMessage.target);
            }
          }

          //MARK: Cuelights
          if(serverMessage.dataType == ServerMessageDataType.cuelight) {
            // serverMessage.timerEvent.
            if(serverMessage.method == ServerMessageMethod.upsert) {
              //convert to object
              var cuelight = ScCueLight.fromJson(serverMessage.data!);
              cuelight.fromRemote = true;
              cuelight.upsert();
            } else if(serverMessage.method == ServerMessageMethod.delete) {
              ScCueLight.delete(serverMessage.target);
            }
          }

        } catch (e) {
          print(e);
        }
        // if(message)
        // channel.sink.add('received!');
        print(message);
        // channel.sink.close(status.goingAway);
      }, onError: (e) {
        print("Websocket Error: $e");
        isConnected.value = false;
        reconnect(wsUrl: wsUrl);
      }, onDone: () {
        print("Websocket Done");
        isConnected.value = false;
        reconnect(wsUrl: wsUrl);
      });
    }

    void disconnect() {
      channel?.sink.close();
      wsStream?.cancel();
      pingTimer?.cancel();
      channel = null;
      isConnected.value = false;
    }
  
    void dispose() {
      disconnect();
      isConnected.dispose();
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