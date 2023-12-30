// import 'package:hive/hive.dart';
// import 'package:shelf/shelf.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:hive/hive.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:stagecon/controllers/OscController.dart';
import 'package:stagecon/types/sc_cuelight.dart';
import 'package:stagecon/types/sc_message.dart';
import 'package:stagecon/types/sc_timer.dart';
import 'package:stagecon/types/server_message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

const int clientPingGracePeriod = 10; //mins

class ScSocketContainer {
  HttpConnectionInfo? connectionInfo;
  WebSocketChannel socket;
  DateTime lastPing = DateTime.now();
  bool get healthy => lastPing.difference(DateTime.now()).inMinutes < clientPingGracePeriod;
  ScSocketContainer(this.socket, {this.connectionInfo});
}

class ServerProxyServerSockets extends ValueNotifier<List<ScSocketContainer>> {
  ServerProxyServerSockets() : super([]);

  void add(ScSocketContainer socket) {
    value.add(socket);
    notifyListeners();
  }

  void remove(ScSocketContainer socket) {
    // socket.socket.
    // value = value.where((element) => element.socket != socket.socket).toList();
    value.remove(socket);
    socket.socket.sink.close(status.goingAway);
    socket.socket.stream.drain();
    notifyListeners();
  }

  void removeSocket(WebSocketChannel socket) {
    value.removeWhere((element) {
        if( element.socket == socket ) {
          socket.sink.close(status.goingAway);
          socket.stream.drain();
          return true;
        } else {
          return false;
        }
    } );
    
    // notifyListeners();
  }

  void closeAll() {
        //close all sockets
    for(var socket in value) {
      socket.socket.sink.close(status.goingAway);
      socket.socket.stream.drain();
    }
    value.clear();
  }

  @override
  void dispose() {
     super.dispose();
     closeAll();

  }
}

class ScProxyServer {
  // OSCcontroler oscCon = Get.find();

  ServerProxyServerSockets sockets = ServerProxyServerSockets();

  StreamSubscription<BoxEvent>? messageSubscription;
  StreamSubscription<BoxEvent>? cueLightSubscription;
  StreamSubscription<BoxEvent>? timerSubscription;

  ValueNotifier<bool> isServing = ValueNotifier(false);

  HttpServer? server;

  //ping chron timer
  Timer? pingTimer;

  Future<Response> serverHandler(Request request) async {
      final connectionInfo = (request.context['shelf.io.connection_info'] as HttpConnectionInfo?);
      
      return webSocketHandler((WebSocketChannel webSocket) {
        // webSocket.
        
        if(webSocket.closeCode != null) {
          print("Removing Closed Websocket.  Previous Length: ${sockets.value.length}");
          sockets.removeSocket(webSocket);
          print("New Length: ${sockets.value.length}");
          return;
        } else {
          print("New Websocket: ${sockets.value.length+1}");
        }
        sockets.add(ScSocketContainer(webSocket, connectionInfo: connectionInfo));
        
        webSocket.stream.listen((message) {
          print(message);
          if(message == "ping") {
            webSocket.sink.add("pong");
            return;
          }
          if(message == "pong") {
            // update last pinged time
            for(var socket in sockets.value) {
              if(socket.socket == webSocket) {
                socket.lastPing = DateTime.now();
              }
            }
          }
          // webSocket.sink.add("echo $message");
        });
      })(request);
    }

  void serve({required int port}) async {
    shutdown();
    //Start the server        
    server = await shelf_io.serve(serverHandler, InternetAddress.anyIPv4, port);
    isServing.value = true;

      
    print('Serving at ws://${server!.address.host}:${server!.port}');
    

    

    ///Ping every minute
    pingTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      pingAll();
    });

    //listen for timer events from hive
    timerSubscription = Hive.box<ScTimer>("timers").watch().listen(onTimerEvent);
    // messageSubscription = Hive.box<ScMessage>("messages").watch().listen(onTimerEvent);
    cueLightSubscription = Hive.box<ScCueLight>("cuelights").watch().listen(onCueLightEvent);


    // oscCon.addTimerEventListener(onTimerEvent);

  }

  onTimerEvent(BoxEvent event) {
    for(var socket in sockets!.value) {
      socket.socket.sink.add(jsonEncode(ServerMessage(
        target: event.key,
        method: event.deleted ? ServerMessageMethod.delete : ServerMessageMethod.upsert,
        data: event.deleted ? null : (event.value as ScTimer).toJson(),
        dataType: ServerMessageDataType.timer
      ).toJson()));
    }
  }

  onMessageEvent(BoxEvent event) {
    for(var socket in sockets!.value) {
      socket.socket.sink.add(jsonEncode(ServerMessage(
        target: event.key,
        method: event.deleted ? ServerMessageMethod.delete : ServerMessageMethod.upsert,
        data: event.deleted ? null : (event.value as ScMessage).toJson(),
        dataType: ServerMessageDataType.timer
      ).toJson()));
    }
  }

  onCueLightEvent(BoxEvent event) {
    for(var socket in sockets!.value) {
      socket.socket.sink.add(jsonEncode(ServerMessage(
        target: event.key,
        method: event.deleted ? ServerMessageMethod.delete : ServerMessageMethod.upsert,
        data: event.deleted ? null : (event.value as ScCueLight).toJson(),
        dataType: ServerMessageDataType.cuelight
      ).toJson()));
    }
  }

  /// Pings all sockets.
  pingAll() {

    //remove and close sockets not returning pings for 10 minutes
    for(var socket in sockets!.value) {
      if(!socket.healthy) {
        socket.socket.sink.close();
        socket.socket.stream.drain();
        sockets!.remove(socket);
      }
    }

    //Ping every socket
    for(var socket in sockets!.value) {
      socket.socket.sink.add("ping");
    }
  }

  void shutdown() {
    isServing.value = false;
    print("Shutting down server");
    // dispose();
    pingTimer?.cancel();
    timerSubscription?.cancel();
    messageSubscription?.cancel();
    cueLightSubscription?.cancel();
    server?.close(force: true);
    sockets.closeAll();
  }


  // @override
  void dispose() {
    // super.dispose();
    shutdown();
    

    isServing.dispose();
    sockets.dispose();
  }
}
//     // var handler =
//     //     const Pipeline().addMiddleware(logRequests()).addHandler(() {
//     //       return;
//     //     });

//     // var server = await shelf_io.serve(handler, 'localhost', 8080);

//     // // Enable content compression
//     // server.autoCompress = true;



//     // print('Serving at http://${server.address.host}:${server.port}');

//     var preferences = await Hive.box('preferences');

//     var handler = SseHandler(Uri.parse('/osc'));
//     await shelf_io.serve(handler.handler, 'localhost', preferences.get("server_port"));
//     var connections = handler.connections;
//     // connections.
//     while (await connections.hasNext) {
//       var connection = await connections.next;
//       // connection.
//       connection.sink.add('foo');
//       connection.stream.listen(print);
//     }

//   }
// }