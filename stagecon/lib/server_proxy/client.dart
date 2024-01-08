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
import 'package:stagecon/types/server_sync_message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

// const int CLIENT_RECONNECT_MAX_ATTEMPTS = 10; //mins

enum ScProxyClientStatus {
  disconnected,
  reconnecting,
  connected,
}

class ScProxyClient {
    OSCcontroler oscCon = Get.find();
    WebSocketChannel? channel;
    DateTime lastPing = DateTime.now();

    // var timerBox = Hive.box<ScTimer>('timers');
    ValueNotifier<ScProxyClientStatus> status = ValueNotifier(ScProxyClientStatus.disconnected);

    StreamSubscription<dynamic>? wsStream;
    
    Timer? pingTimer; 
    Timer? reconnectTimer; 

    int reconnectAttempts = 0;

    // Uri? wsUrl;
    String? host;
    int? port;
    ScProxyClient() {
      // reconnect();
    }
      //check to see if we have recieved a ping in the last 1 mins
    _periodicPing(Timer timer) {
      if(DateTime.now().difference(lastPing) > const Duration(minutes: 1)) {
        print("No ping in 1 minutes.  Reconnecting");
        
        reconnect();
      }
    }

    /// Syncs all timers, messages and cuelights with the server to get the latest state.  periodically call this to keep the app in sync with the server
    Future<void> resync() async {
      //make a call to the server to get all objects 

      final response = await http.get(Uri.parse('http://$host:$port/v1/api/sync'));
      if(response.statusCode != 200) {
        throw Exception('Failed to load data');
      }
      ServerSyncMessage sync;
      try{
        sync = ServerSyncMessage.fromJson(jsonDecode(response.body), fromRemote: true);
      } catch (e) {
        rethrow;
      }
      
      //remove all remote objects
      await Future.wait([
        ScTimer.deleteAllRemote(),
        ScMessage.deleteAllRemote(),
        ScCueLight.deleteAllRemote(),
      ]);

      //save all the new objects

      List<Future> futures = [];

        for(var timerJson in sync.timers) {
          futures.add(timerJson.upsert());
        }
      
        for(var messageJson in sync.messages) {
          futures.add(messageJson.upsert());
        }
      
        for(var cuelightJson in sync.cuelights) {
          futures.add(cuelightJson.upsert());
        }
      


      await Future.wait(futures);
      
      
    }

    // List test = [];
    reconnect() async {
      Uri useableWsUrl;
      if(host != null && port != null) {
        useableWsUrl = Uri.parse('ws://$host:$port/v1/ws');
      } else {
        throw Exception("No host or port provided and no previous wsUrl set");
      }

      
      disconnect();
      status.value = ScProxyClientStatus.reconnecting;
      reconnectAttempts++;

      try {
        channel = WebSocketChannel.connect(useableWsUrl);
        await channel!.ready;
        print("Connected to $useableWsUrl");
        // channel.
      } catch (e) {
        print("Failed to connect to $useableWsUrl");
        print(e);

        //try to reconnect
        reconnectTimer = Timer(const Duration(seconds: 5), () {
          
          reconnect();
        });

        return;
      }
      
      print("Listening as client to $useableWsUrl");


      status.value = ScProxyClientStatus.connected;
      reconnectAttempts = 0;
      

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
              serverMessage.data!["fromRemote"] = true;
              var timer = ScTimer.fromJson(serverMessage.data!);
              timer.upsert();
            } else if(serverMessage.method == ServerMessageMethod.delete) {
              ScTimer.delete("remote_${serverMessage.target}");
            }
          }

          // //MARK: Messages
          if(serverMessage.dataType == ServerMessageDataType.message) {
            // serverMessage.timerEvent.
            if(serverMessage.method == ServerMessageMethod.upsert) {
              //convert to object
              serverMessage.data!["fromRemote"] = true;
              var message = ScMessage.fromJson(serverMessage.data!);

              message.upsert();
            } else if(serverMessage.method == ServerMessageMethod.delete) {
              ScMessage.delete("remote_${serverMessage.target}");
            }
          }

          //MARK: Cuelights
          if(serverMessage.dataType == ServerMessageDataType.cuelight) {
            // serverMessage.timerEvent.
            if(serverMessage.method == ServerMessageMethod.upsert) {
              //convert to object
              serverMessage.data!["fromRemote"] = true;
              var cuelight = ScCueLight.fromJson(serverMessage.data!);
              // cuelight.fromRemote = true;
              cuelight.upsert();
            } else if(serverMessage.method == ServerMessageMethod.delete) {
              ScCueLight.delete("remote_${serverMessage.target}");
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
        
        reconnect();
      }, onDone: () {
        print("Websocket Done");
        
        reconnect();
      });


      //resync all timers
      await resync();
    }

    void disconnect() {
      channel?.sink.close();
      wsStream?.cancel();
      pingTimer?.cancel();
      reconnectTimer?.cancel();
      channel = null;
      status.value = ScProxyClientStatus.disconnected;
    }
  
    void dispose() {
      disconnect();
      status.dispose();
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